@testable import Vlaggen
import Foundation
import VlaggenNetworkModels

final class DefaultVlaggenMemoryStoreMock: VlaggenMemoryStoreLogic {

    var invokedGet = false
    var invokedGetCount = 0
    var invokedGetParameters: (key: String, Void)?
    var invokedGetParametersList = [(key: String, Void)]()
    var stubbedGetResult: ParameterResponse!

    func get(key: String) -> ParameterResponse? {
        invokedGet = true
        invokedGetCount += 1
        invokedGetParameters = (key, ())
        invokedGetParametersList.append((key, ()))
        return stubbedGetResult
    }

    var invokedStore = false
    var invokedStoreCount = 0
    var invokedStoreParameters: (parameters: [ParameterResponse], Void)?
    var invokedStoreParametersList = [(parameters: [ParameterResponse], Void)]()

    func store(parameters: [ParameterResponse]) {
        invokedStore = true
        invokedStoreCount += 1
        invokedStoreParameters = (parameters, ())
        invokedStoreParametersList.append((parameters, ()))
    }
}
