import Foundation
import VlaggenNetworkModels

protocol VlaggenDiskStoreLogic {
    func list() -> Result<[ParameterResponse], Error>

    func store(parameters: [ParameterResponse])
}

private enum Constants {

    struct Folder {
        static let name = "vlaggen"
        static let path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0])
            .appendingPathComponent(name)
    }

    static let fileName = "parameters.json"
}

final class VlaggenDiskStore: VlaggenDiskStoreLogic {

    private let storage: CodableStorageLogic

    init(storage: CodableStorageLogic = CodableStorage(storage: DiskStorage(path: Constants.Folder.path))) {
        self.storage = storage
    }

    func list() -> Result<[ParameterResponse], Error> {
        do {
            let parameters: [ParameterResponse] = try storage.fetch(for: Constants.fileName)
            return .success(parameters)
        } catch {
            return .failure(error)
        }
    }

    func store(parameters: [ParameterResponse]) {
        do {
            try storage.save(parameters, for: Constants.fileName)
        } catch {
            print("Vlaggen is unable to store \(Constants.fileName) because of \(error)")
        }
    }
}
