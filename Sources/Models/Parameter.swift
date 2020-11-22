import Foundation

public struct Parameter {
    public let key: String
    public let value: Any

    init(key: String, value: Any) {
        self.key = key
        self.value = value
    }
}
