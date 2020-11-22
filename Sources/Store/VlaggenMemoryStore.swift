import Foundation
import VlaggenNetworkModels

protocol VlaggenMemoryStoreLogic {
    func get(key: String) -> ParameterResponse?
    func store(parameters: [ParameterResponse])
}

final class VlaggenMemoryStore: VlaggenMemoryStoreLogic {
    private var parameters: [ParameterResponse] = []

    func get(key: String) -> ParameterResponse? {
        return parameters.first { $0.key == key }
    }

    func store(parameters: [ParameterResponse]) {
        self.parameters = parameters
    }
}
