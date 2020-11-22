import Foundation
import VlaggenNetworking
import VlaggenNetworkModels
import Moya

protocol VlaggenRemoteStoreLogic {
    func list(completion: @escaping (Result<[ParameterResponse], Error>) -> Void)
}

final class VlaggenRemoteStore: VlaggenRemoteStoreLogic {
    private let client: ParameterAsyncNetworkable

    init(client: ParameterAsyncNetworkable = ParameterAsyncNetwork()) {
        self.client = client
    }

    func list(completion: @escaping (Result<[ParameterResponse], Error>) -> Void) {
        client.list { (result) in
            switch result {
                case .success(let parameters):
                    completion(.success(parameters))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

public extension ParameterAsyncNetwork {
    convenience init() {
        guard let settings = Vlaggen.settings else {
            fatalError("Did not initialise Vlaggen. Initialise by using Vlaggen#set(url:)")
        }

        self.init(server: settings.server)
    }
}
