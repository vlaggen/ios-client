@testable import Vlaggen
import Foundation

final class DefaultFileManagerMock: FileManagerLogic {

    var invokedContents = false
    var invokedContentsCount = 0
    var invokedContentsParameters: (path: String, Void)?
    var invokedContentsParametersList = [(path: String, Void)]()
    var stubbedContentsResult: Data!

    func contents(atPath path: String) -> Data? {
        invokedContents = true
        invokedContentsCount += 1
        invokedContentsParameters = (path, ())
        invokedContentsParametersList.append((path, ()))
        return stubbedContentsResult
    }

    var invokedFileExists = false
    var invokedFileExistsCount = 0
    var invokedFileExistsParameters: (path: String, Void)?
    var invokedFileExistsParametersList = [(path: String, Void)]()
    var stubbedFileExistsResult: Bool! = false

    func fileExists(atPath path: String) -> Bool {
        invokedFileExists = true
        invokedFileExistsCount += 1
        invokedFileExistsParameters = (path, ())
        invokedFileExistsParametersList.append((path, ()))
        return stubbedFileExistsResult
    }

    var invokedCreateDirectory = false
    var invokedCreateDirectoryCount = 0
    var invokedCreateDirectoryParameters: (url: URL, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)?
    var invokedCreateDirectoryParametersList = [(url: URL, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)]()
    var stubbedCreateDirectoryError: Error?

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        invokedCreateDirectory = true
        invokedCreateDirectoryCount += 1
        invokedCreateDirectoryParameters = (url, createIntermediates, attributes)
        invokedCreateDirectoryParametersList.append((url, createIntermediates, attributes))
        if let error = stubbedCreateDirectoryError {
            throw error
        }
    }
}
