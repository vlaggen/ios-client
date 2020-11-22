import Foundation

protocol ReadableStorage {
    func get(for key: String) throws -> Data
}

protocol WritableStorage {
    func save(value: Data, for key: String) throws
}
