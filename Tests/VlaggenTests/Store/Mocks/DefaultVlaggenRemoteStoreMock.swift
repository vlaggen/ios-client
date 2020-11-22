@testable import Vlaggen
import Foundation
import VlaggenNetworkModels

final class DefaultVlaggenRemoteStoreMock: VlaggenRemoteStoreLogic {

    var invokedList = false
    var invokedListCount = 0
    var stubbedListCompletionResult: (Result<[ParameterResponse], Error>, Void)?

    func list(completion: @escaping (Result<[ParameterResponse], Error>) -> Void) {
        invokedList = true
        invokedListCount += 1
        if let result = stubbedListCompletionResult {
            completion(result.0)
        }
    }
}
