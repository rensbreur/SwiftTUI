import Foundation

/// To enable logging, create an empty file under `/tmp/swift_tui_log`.
///
/// You can then also monitor the log live:
/// ```
/// tail -f /tmp/swift_tui_log
/// ```
func log(_ item: Any) {
    print(item, to: &logStream)
}

var logStream = LogStream()

struct LogStream: TextOutputStream {
    func write(_ string: String) {
        let logURL = URL(fileURLWithPath: "/tmp/swift_tui_log")
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

