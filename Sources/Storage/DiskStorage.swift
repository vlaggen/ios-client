import Foundation

class DiskStorage {
    private let fileManager: FileManagerLogic
    private let path: URL
    private let diskWriter: DiskStorageDataWriterLogic

    init(path: URL,
         fileManager: FileManagerLogic = FileManager.default,
         diskWriter: DiskStorageDataWriterLogic = DiskStorageDataWriter()
    ) {
        self.path = path
        self.fileManager = fileManager
        self.diskWriter = diskWriter
    }
}

extension DiskStorage: ReadableStorage {
    func get(for key: String) throws -> Data {

        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }
}

extension DiskStorage: WritableStorage {

    func save(value: Data, for key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try self.createFolders(in: url)
            try diskWriter.write(data: value, to: url, options: .atomic)
        } catch {
            throw StorageError.write(error)
        }
    }
}

private extension DiskStorage {
    func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        guard !fileManager.fileExists(atPath: folderUrl.path) else {
            return
        }

        try fileManager.createDirectory(
            at: folderUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
