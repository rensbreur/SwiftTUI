import Foundation

/// `Int` extended with infinity values, used by certain modifiers such as `.frame(maxWidth:)` to
/// allow views taking up all necessary space.
public struct Extended: Equatable {
    fileprivate let data: Data

    fileprivate enum Data {
        case number(Int)
        case positiveInfinity
        case negativeInfinity
    }

    public static func == (lhs: Extended, rhs: Extended) -> Bool {
        switch (lhs.data, rhs.data) {
        case (.positiveInfinity, .positiveInfinity):
            return true
        case (.negativeInfinity, .negativeInfinity):
            return true
        case (.number(let a), .number(let b)):
            return a == b
        default:
            return false
        }
    }

    fileprivate init(data: Data) {
        self.data = data
    }

    public init(_ value: Int) {
        self.data = .number(value)
    }

    public static var infinity: Self {
        Extended(data: .positiveInfinity)
    }

    public var intValue: Int {
        guard case let .number(a) = data else {
            fatalError("Cannot convert infinite number to int")
        }
        return a
    }
}

extension Extended: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension Extended: AdditiveArithmetic {
    public static func -(lhs: Extended, rhs: Extended) -> Extended {
        switch (lhs.data, rhs.data) {
        case (.number(let a), .number(let b)):
            return Extended(a - b)
        case (.positiveInfinity, .number):
            return Extended(data: .positiveInfinity)
        case (.negativeInfinity, .number):
            return Extended(data: .negativeInfinity)
        case (.number, .positiveInfinity):
            return Extended(data: .negativeInfinity)
        case (.number, .negativeInfinity):
            return Extended(data: .positiveInfinity)
        case (.positiveInfinity, .negativeInfinity):
            return Extended(data: .positiveInfinity)
        case (.negativeInfinity, .positiveInfinity):
            return Extended(data: .negativeInfinity)
        case (.negativeInfinity, .negativeInfinity):
            fatalError("Cannot subtract infinity from infinity")
        case (.positiveInfinity, .positiveInfinity):
            fatalError("Cannot subtract infinity from infinity")
        }
    }

    public static func +(lhs: Extended, rhs: Extended) -> Extended {
        switch (lhs.data, rhs.data) {
        case (.number(let a), .number(let b)):
            return Extended(a + b)
        case (.positiveInfinity, .number):
            return Extended(data: .positiveInfinity)
        case (.negativeInfinity, .number):
            return Extended(data: .negativeInfinity)
        case (.number, .positiveInfinity):
            return Extended(data: .positiveInfinity)
        case (.number, .negativeInfinity):
            return Extended(data: .negativeInfinity)
        case (.positiveInfinity, .negativeInfinity):
            fatalError("Cannot subtract infinity from infinity")
        case (.negativeInfinity, .positiveInfinity):
            fatalError("Cannot subtract infinity from infinity")
        case (.negativeInfinity, .negativeInfinity):
            return Extended(data: .negativeInfinity)
        case (.positiveInfinity, .positiveInfinity):
            return Extended(data: .positiveInfinity)
        }
    }
}

extension Extended: Comparable {
    public static func <(lhs: Extended, rhs: Extended) -> Bool {
        switch (lhs.data, rhs.data) {
        case (.number(let a), .number(let b)):
            return a < b
        case (.positiveInfinity, .positiveInfinity):
            return false
        case (.negativeInfinity, .negativeInfinity):
            return false
        case (.positiveInfinity, .number):
            return false
        case (.number, .positiveInfinity):
            return true
        case (.negativeInfinity, .number):
            return true
        case (.number, .negativeInfinity):
            return false
        case (.negativeInfinity, .positiveInfinity):
            return true
        case (.positiveInfinity, .negativeInfinity):
            return false
        }
    }
}

extension Extended {
    public static func *(lhs: Extended, rhs: Extended) -> Extended {
        switch (lhs.data, rhs.data) {
        case (.number(let a), .number(let b)):
            return Extended(a * b)
        case (.positiveInfinity, .positiveInfinity):
            return Extended(data: .positiveInfinity)
        case (.negativeInfinity, .negativeInfinity):
            return Extended(data: .positiveInfinity)
        case (.positiveInfinity, .number(let a)):
            if a > 0 {
                return Extended(data: .positiveInfinity)
            } else {
                return Extended(data: .negativeInfinity)
            }
        case (.number(let a), .positiveInfinity):
            if a > 0 {
                return Extended(data: .positiveInfinity)
            } else {
                return Extended(data: .negativeInfinity)
            }
        case (.negativeInfinity, .number(let a)):
            if a > 0 {
                return Extended(data: .negativeInfinity)
            } else {
                return Extended(data: .positiveInfinity)
            }
        case (.number(let a), .negativeInfinity):
            if a > 0 {
                return Extended(data: .negativeInfinity)
            } else {
                return Extended(data: .positiveInfinity)
            }
        case (.negativeInfinity, .positiveInfinity):
            return Extended(data: .negativeInfinity)
        case (.positiveInfinity, .negativeInfinity):
            return Extended(data: .negativeInfinity)
        }
    }

    public static func /(lhs: Extended, rhs: Extended) -> Extended {
        switch (lhs.data, rhs.data) {
        case (.number(let a), .number(let b)):
            if b == 0 {
                return .infinity
            } else {
                return Extended(a / b)
            }
        case (.positiveInfinity, .number(let a)):
            if a > 0 {
                return Extended(data: .positiveInfinity)
            } else {
                return Extended(data: .negativeInfinity)
            }
        case (.negativeInfinity, .number(let a)):
            if a > 0 {
                return Extended(data: .negativeInfinity)
            } else {
                return Extended(data: .positiveInfinity)
            }
        case (.number, .positiveInfinity):
            return Extended(0)
        case (.number, .negativeInfinity):
            return Extended(0)
        case (.positiveInfinity, .positiveInfinity):
            fatalError("Cannot divide infinity by infinity")
        case (.negativeInfinity, .negativeInfinity):
            fatalError("Cannot divide infinity by infinity")
        case (.negativeInfinity, .positiveInfinity):
            fatalError("Cannot divide infinity by infinity")
        case (.positiveInfinity, .negativeInfinity):
            fatalError("Cannot divide infinity by infinity")
        }
    }

    public static prefix func -(value: Extended) -> Extended {
        switch value.data {
        case .number(let a):
            return Extended(-a)
        case .positiveInfinity:
            return Extended(data: .negativeInfinity)
        case .negativeInfinity:
            return Extended(data: .positiveInfinity)
        }
    }
}

public func max(_ a: Extended, _ b: Extended) -> Extended {
    switch (a.data, b.data) {
    case (.number(let a), .number(let b)):
        return Extended(max(a, b))
    case (.negativeInfinity, .number(let a)):
        return Extended(a)
    case (.number(let a), .negativeInfinity):
        return Extended(a)
    case (.positiveInfinity, .positiveInfinity):
        return Extended(data: .positiveInfinity)
    case (.negativeInfinity, .negativeInfinity):
        return Extended(data: .negativeInfinity)
    case (.positiveInfinity, .number):
        return Extended(data: .positiveInfinity)
    case (.number, .positiveInfinity):
        return Extended(data: .positiveInfinity)
    case (.negativeInfinity, .positiveInfinity):
        return Extended(data: .positiveInfinity)
    case (.positiveInfinity, .negativeInfinity):
        return Extended(data: .positiveInfinity)
    }
}

extension Extended: CustomStringConvertible {
    public var description: String {
        switch data {
        case .positiveInfinity:
            return "∞"
        case .negativeInfinity:
            return "-∞"
        case .number(let a):
            return "\(a)"
        }
    }
}
