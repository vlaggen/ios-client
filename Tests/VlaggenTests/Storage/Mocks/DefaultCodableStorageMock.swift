@testable import Vlaggen
import Foundation
import VlaggenNetworkModels

final class DefaultCodableStorageMock: CodableStorageLogic {

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (key: String, Void)?
    var invokedFetchParametersList = [(key: String, Void)]()
    var stubbedFetchError: Error?
    var stubbedFetchResult: Any!

    func fetch<T: Decodable>(for key: String) throws -> T {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (key, ())
        invokedFetchParametersList.append((key, ()))
        if let error = stubbedFetchError {
            throw error
        }
        return stubbedFetchResult as! T
    }

    var invokedSave = false
    var invokedSaveCount = 0
    var invokedSaveParameters: (value: Any, key: String)?
    var invokedSaveParametersList = [(value: Any, key: String)]()
    var stubbedSaveError: Error?

    func save<T: Encodable>(_ value: T, for key: String) throws {
        invokedSave = true
        invokedSaveCount += 1
        invokedSaveParameters = (value, key)
        invokedSaveParametersList.append((value, key))
        if let error = stubbedSaveError {
            throw error
        }
    }
}
