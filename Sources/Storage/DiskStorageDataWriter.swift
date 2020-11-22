import Foundation

protocol DiskStorageDataWriterLogic {
    func write(data: Data, to url: URL, options: Data.WritingOptions) throws
}

final class DiskStorageDataWriter: DiskStorageDataWriterLogic {
    func write(data: Data, to url: URL, options: Data.WritingOptions = []) throws {
        try data.write(to: url, options: options)
    }
}
