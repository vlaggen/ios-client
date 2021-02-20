import Foundation
import VlaggenNetworking
import VlaggenNetworkModels

public protocol VlaggenControllerLogic {

    func fetch(conditions: [String: String], completion: @escaping (Result<[Parameter],Error>) -> Void)

    func get<T: Decodable>(key: String, as: T.Type) -> T?
    func get<T: Decodable>(key: String, as: T.Type, fallback: T) -> T
}

public final class VlaggenController: VlaggenControllerLogic {
    private let memoryStore: VlaggenMemoryStoreLogic
    private let diskStore: VlaggenDiskStoreLogic
    private let remoteStore: VlaggenRemoteStoreLogic

    private let decoder: JSONDecoder

    init(memoryStore: VlaggenMemoryStoreLogic = VlaggenMemoryStore(),
         diskStore: VlaggenDiskStoreLogic = VlaggenDiskStore(),
         remoteStore: VlaggenRemoteStoreLogic = VlaggenRemoteStore(),
         decoder: JSONDecoder = JSONDecoder()
    ) {
        self.memoryStore = memoryStore
        self.diskStore = diskStore
        self.remoteStore = remoteStore
        self.decoder = decoder

        if case let .success(parameters) = diskStore.list() {
            self.memoryStore.store(parameters: parameters)
        }
    }

    public func fetch(conditions: [String: String], completion: @escaping (Result<[Parameter], Error>) -> Void) {
        remoteStore.list(conditions: conditions) { [weak self] (result) in
            switch result {
                case .success(let responses):
                    self?.memoryStore.store(parameters: responses)
                    self?.diskStore.store(parameters: responses)

                    let parameters = responses.compactMap { response -> Parameter? in
                        let wrappedValue = response.value
                        let key = response.key
                        if case let .string(value) = wrappedValue {
                            return Parameter(key: key, value: value)
                        } else if case let .double(value) = wrappedValue {
                            return Parameter(key: key, value: value)
                        } else if case let .bool(value) = wrappedValue {
                            return Parameter(key: key, value: value)
                        }

                        return nil
                    }

                    completion(.success(parameters))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    public func get<T: Decodable>(key: String, as type: T.Type) -> T? {
        let wrappedValue = memoryStore.get(key: key)?.value
        if case let .string(value) = wrappedValue {
            if let data = value.data(using: .utf8) {
                if let decoded = try? decoder.decode(type, from: data) {
                    return decoded
                }
            }
            return value as? T
        } else if case let .double(value) = wrappedValue {
            return value as? T
        } else if case let .bool(value) = wrappedValue {
            return value as? T
        }

        return nil
    }

    public func get<T>(key: String, as type: T.Type, fallback: T) -> T where T : Decodable {
        return get(key: key, as: type) ?? fallback
    }
}

extension VlaggenController {
    public static let shared = VlaggenController()
}
