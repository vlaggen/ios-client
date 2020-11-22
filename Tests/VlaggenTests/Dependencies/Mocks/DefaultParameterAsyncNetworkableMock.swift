@testable import Vlaggen
import Foundation
import VlaggenNetworking
import VlaggenNetworkModels
import Moya

final class DefaultParameterAsyncNetworkableMock: ParameterAsyncNetworkable {

    var invokedList = false
    var invokedListCount = 0
    var stubbedListCompletionResult: (Result<[ParameterResponse], MoyaError>, Void)?

    func list(completion: @escaping (Result<[ParameterResponse], MoyaError>) -> Void) {
        invokedList = true
        invokedListCount += 1
        if let result = stubbedListCompletionResult {
            completion(result.0)
        }
    }
}
