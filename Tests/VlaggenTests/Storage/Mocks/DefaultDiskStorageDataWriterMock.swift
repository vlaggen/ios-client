@testable import Vlaggen

import Foundation

final class DefaultDiskStorageDataWriterMock: DiskStorageDataWriterLogic {

    var invokedWrite = false
    var invokedWriteCount = 0
    var invokedWriteParameters: (data: Data, url: URL, options: Data.WritingOptions)?
    var invokedWriteParametersList = [(data: Data, url: URL, options: Data.WritingOptions)]()
    var stubbedWriteError: Error?

    func write(data: Data, to url: URL, options: Data.WritingOptions) throws {
        invokedWrite = true
        invokedWriteCount += 1
        invokedWriteParameters = (data, url, options)
        invokedWriteParametersList.append((data, url, options))
        if let error = stubbedWriteError {
            throw error
        }
    }
}
