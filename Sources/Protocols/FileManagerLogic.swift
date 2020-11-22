import Foundation

protocol FileManagerLogic {
    func contents(atPath path: String) -> Data?
    func fileExists(atPath path: String) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

extension FileManager: FileManagerLogic {}
