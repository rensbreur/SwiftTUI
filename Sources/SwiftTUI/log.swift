import Foundation

/// To enable logging, create an empty file or a named socket
/// as `swift_tui_log` in the tmp directory.
func log(_ item: Any) {
    print(item, to: &logStream)
}

var logStream = LogStream()

struct LogStream: TextOutputStream {
    func write(_ string: String) {
        let logURL = FileManager.default.temporaryDirectory.appendingPathComponent("swift_tui_log")
        guard let data = string.data(using: .utf8) else {
            assertionFailure("Cannot write to log")
            return
        }
        if let fileHandle = try? FileHandle(forWritingTo: logURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        }
    }
}

