import Foundation

// Raw key events.
//
// SwiftTUI decodes only bare arrow keys and routes them to focus movement
// (see ArrowKeyParser + Application.handleInput). Apps that need a raw-key
// interaction model — arrows with modifiers, Page keys, a bare Esc, and
// printable characters — have no way in. This file adds a public key-event
// type and a chunk parser; `Application.keyHandler` (see Application.swift)
// opts an app into receiving these instead of focus handling.
//
// The parser reports what was pressed (key + modifiers) and attaches no
// meaning to it; bindings are entirely up to the app.

/// A decoded key press delivered to `Application.keyHandler`: a key plus any
/// modifier keys held with it.
public struct RawKeyEvent: Equatable {
    /// The key that was pressed.
    public enum Key: Equatable {
        case up, down, left, right
        case pageUp, pageDown
        case home, end
        case f1
        case escape
        case enter
        case backspace
        /// A printable character.
        case char(Character)
    }

    /// Modifier keys, as reported by the terminal's escape-sequence encoding.
    public struct Modifiers: OptionSet, Equatable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let shift   = Modifiers(rawValue: 1 << 0)
        /// Option on macOS; Alt/Meta elsewhere.
        public static let option  = Modifiers(rawValue: 1 << 1)
        public static let control = Modifiers(rawValue: 1 << 2)
    }

    public let key: Key
    public let modifiers: Modifiers

    public init(_ key: Key, modifiers: Modifiers = []) {
        self.key = key
        self.modifiers = modifiers
    }
}

/// Decodes a chunk of terminal input bytes into discrete key events.
///
/// SwiftTUI reads input a chunk at a time (`FileHandle.availableData`). Terminals
/// deliver a full escape sequence in a single chunk, and a bare Esc press arrives
/// as a lone `ESC` byte, so the bare-Esc/escape-sequence ambiguity can be resolved
/// by looking at the whole chunk without a read timeout. (A lone `ESC` immediately
/// followed in the same chunk by an unrelated key — rare, e.g. a fast Meta combo —
/// is treated as Esc.)
public enum RawKeyParser {
    public static func parse(_ string: String) -> [RawKeyEvent] {
        let ch = Array(string)
        var events: [RawKeyEvent] = []
        var i = 0
        while i < ch.count {
            let c = ch[i]
            switch c {
            case "\u{1b}": // ESC — possibly the start of a sequence
                let (event, consumed) = parseEscape(ch, i)
                if let event { events.append(event) }
                i += consumed
            case "\r", "\n":
                events.append(RawKeyEvent(.enter)); i += 1
            case "\u{7f}", "\u{08}":
                events.append(RawKeyEvent(.backspace)); i += 1
            default:
                // Skip other C0 control bytes; pass printable characters through.
                if let scalar = c.unicodeScalars.first, scalar.value < 0x20 {
                    i += 1
                } else {
                    events.append(RawKeyEvent(.char(c))); i += 1
                }
            }
        }
        return events
    }

    /// Parses an escape sequence starting at `i` (where `ch[i] == ESC`).
    /// Returns the event (or nil for an unrecognized/incomplete sequence) and the
    /// number of characters consumed.
    private static func parseEscape(_ ch: [Character], _ i: Int) -> (RawKeyEvent?, Int) {
        let n = ch.count
        // Lone ESC at the end of the chunk → bare Escape.
        guard i + 1 < n else { return (RawKeyEvent(.escape), 1) }
        let c1 = ch[i + 1]

        // `ESC ESC [ A/B/C/D` — the Meta/Option-arrow variant some terminals send.
        if c1 == "\u{1b}" {
            if i + 3 < n, ch[i + 2] == "[" {
                switch ch[i + 3] {
                case "A": return (RawKeyEvent(.up, modifiers: .option), 4)
                case "B": return (RawKeyEvent(.down, modifiers: .option), 4)
                case "C": return (RawKeyEvent(.right, modifiers: .option), 4)
                case "D": return (RawKeyEvent(.left, modifiers: .option), 4)
                default: break
                }
            }
            // `ESC ESC <other>`: treat the first ESC as a bare Escape.
            return (RawKeyEvent(.escape), 1)
        }

        // CSI (`ESC [ …`) or SS3 application-cursor mode (`ESC O …`).
        if c1 == "[" || c1 == "O" {
            var j = i + 2
            var params = ""
            while j < n {
                let cj = ch[j]
                if cj.isLetter || cj == "~" { // final byte
                    return (csiEvent(prefix: c1, params: params, final: cj), j - i + 1)
                }
                params.append(cj)
                j += 1
            }
            // Incomplete sequence in this chunk — consume it, emit nothing.
            return (nil, n - i)
        }

        // ESC followed by an ordinary character (unsupported Meta combo): treat
        // the ESC as a bare Escape and let the next character parse on its own.
        return (RawKeyEvent(.escape), 1)
    }

    private static func csiEvent(prefix: Character, params: String, final: Character) -> RawKeyEvent? {
        // SS3: application-cursor-mode keys (`ESC O A` etc.), sent unmodified.
        if prefix == "O" {
            switch final {
            case "A": return RawKeyEvent(.up)
            case "B": return RawKeyEvent(.down)
            case "C": return RawKeyEvent(.right)
            case "D": return RawKeyEvent(.left)
            case "H": return RawKeyEvent(.home)
            case "F": return RawKeyEvent(.end)
            case "P": return RawKeyEvent(.f1)   // SS3 F1
            default: return nil
            }
        }

        // CSI. Parameters are `key` or `key;modifier` (xterm encoding), e.g.
        // `1;3 A` is Option-Up and `5;5 ~` is Ctrl-Page Up.
        let parts = params.split(separator: ";", omittingEmptySubsequences: false)
        let keyParam = parts.count > 0 ? String(parts[0]) : ""
        let modifiers = parts.count > 1 ? modifiers(fromXtermParam: String(parts[1])) : []

        switch final {
        case "A": return RawKeyEvent(.up, modifiers: modifiers)
        case "B": return RawKeyEvent(.down, modifiers: modifiers)
        case "C": return RawKeyEvent(.right, modifiers: modifiers)
        case "D": return RawKeyEvent(.left, modifiers: modifiers)
        case "H": return RawKeyEvent(.home, modifiers: modifiers)
        case "F": return RawKeyEvent(.end, modifiers: modifiers)
        case "~":
            switch keyParam {
            case "1", "7": return RawKeyEvent(.home, modifiers: modifiers)     // Home (vt220 / rxvt forms)
            case "4", "8": return RawKeyEvent(.end, modifiers: modifiers)      // End
            case "5": return RawKeyEvent(.pageUp, modifiers: modifiers)        // Page Up
            case "6": return RawKeyEvent(.pageDown, modifiers: modifiers)      // Page Down
            case "11": return RawKeyEvent(.f1, modifiers: modifiers)           // F1 (CSI form)
            default: return nil
            }
        default:
            return nil
        }
    }

    /// Decodes the xterm modifier parameter: its value minus one is a bitfield
    /// of 1 = Shift, 2 = Alt/Option, 4 = Control.
    private static func modifiers(fromXtermParam param: String) -> RawKeyEvent.Modifiers {
        guard let value = Int(param), value > 1 else { return [] }
        let bits = value - 1
        var modifiers: RawKeyEvent.Modifiers = []
        if bits & 1 != 0 { modifiers.insert(.shift) }
        if bits & 2 != 0 { modifiers.insert(.option) }
        if bits & 4 != 0 { modifiers.insert(.control) }
        return modifiers
    }
}
