import Foundation

protocol CodableStorageLogic {
    func fetch<T: Decodable>(for key: String) throws -> T
    func save<T: Encodable>(_ value: T, for key: String) throws
}

class CodableStorage: CodableStorageLogic {
    private let storage: (WritableStorage & ReadableStorage)
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(storage: (WritableStorage & ReadableStorage),
         decoder: JSONDecoder = .init(),
         encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.get(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}
