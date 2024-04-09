import Foundation

class WeakSet<Value> where Value: AnyObject {
    private var data: [Int: Weak<Value>] = [:]

    func add(_ value: Value) {
        data[ObjectIdentifier(value).hashValue] = Weak(value: value)
    }

    var values: [Value] {
        Array(data.values.compactMap(\.value))
    }
}
