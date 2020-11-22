import Foundation

enum StorageError: Error {
    case notFound
    case write(Error)
}
