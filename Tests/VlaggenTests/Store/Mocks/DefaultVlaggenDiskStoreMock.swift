@testable import Vlaggen
import Foundation
import VlaggenNetworkModels

final class DefaultVlaggenDiskStoreMock: VlaggenDiskStoreLogic {

    var invokedList = false
    var invokedListCount = 0
    var stubbedListResult: Result<[ParameterResponse], Error>!

    func list() -> Result<[ParameterResponse], Error> {
        invokedList = true
        invokedListCount += 1
        return stubbedListResult
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
