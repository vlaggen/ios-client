@testable import Vlaggen
import Foundation

final class DefaultStorageMock: WritableStorage, ReadableStorage {

    var invokedSave = false
    var invokedSaveCount = 0
    var invokedSaveParameters: (value: Data, key: String)?
    var invokedSaveParametersList = [(value: Data, key: String)]()
    var stubbedSaveError: Error?

    func save(value: Data, for key: String) throws {
        invokedSave = true
        invokedSaveCount += 1
        invokedSaveParameters = (value, key)
        invokedSaveParametersList.append((value, key))
        if let error = stubbedSaveError {
            throw error
        }
    }

    var invokedGet = false
    var invokedGetCount = 0
    var invokedGetParameters: (key: String, Void)?
    var invokedGetParametersList = [(key: String, Void)]()
    var stubbedGetError: Error?
    var stubbedGetResult: Data!

    func get(for key: String) throws -> Data {
        invokedGet = true
        invokedGetCount += 1
        invokedGetParameters = (key, ())
        invokedGetParametersList.append((key, ()))
        if let error = stubbedGetError {
            throw error
        }
        return stubbedGetResult
    }
}
