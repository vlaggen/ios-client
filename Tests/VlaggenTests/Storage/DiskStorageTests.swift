@testable import Vlaggen
import XCTest

final class DiskStorageTests: XCTestCase {

    var mockURL: URL!
    var mockFileManager: DefaultFileManagerMock!
    var mockDataStorageDiskWriter: DefaultDiskStorageDataWriterMock!

    var sut: DiskStorage!

    override func setUp() {
        mockURL = URL(fileURLWithPath: NSTemporaryDirectory())
        mockFileManager = DefaultFileManagerMock()
        mockDataStorageDiskWriter = DefaultDiskStorageDataWriterMock()

        sut = DiskStorage(path: mockURL, fileManager: mockFileManager, diskWriter: mockDataStorageDiskWriter)
    }

    // MARK: - Get

    func test_get_withUnknownFile_shouldThrowNotFoundError() throws {
        // Given
        let key = "key of thing"

        // When
        XCTAssertThrowsError(try sut.get(for: key)) { (error) in
            guard case StorageError.notFound = error else {
                return XCTFail()
            }
        }

        // Then
        XCTAssertTrue(mockFileManager.invokedContentsParameters?.path.contains("key of thing") ?? false)
    }

    func test_get_withContent_shouldReturnData() throws {
        // Given
        mockFileManager.stubbedContentsResult = "valid data".data(using: .utf8)

        // When
        let result = try sut.get(for: "key")

        // Then
        let expectedData = "valid data".data(using: .utf8)
        XCTAssertEqual(result, expectedData)
    }

    // MARK: - Save

    func test_save_withData_shouldWriteDataToDisk() throws {
        // Given
        let key = "key.txt"
        let data = "valid data".data(using: .utf8) ?? Data()

        // When
        try sut.save(value: data, for: key)

        // Then
        let expectedData = "valid data".data(using: .utf8)
        let expectedURL = mockURL.appendingPathComponent(key)
        XCTAssertEqual(mockDataStorageDiskWriter.invokedWriteParameters?.data, expectedData)
        XCTAssertEqual(mockDataStorageDiskWriter.invokedWriteParameters?.url, expectedURL)
    }

    func test_save_withExistingFile_shouldNotCreateDirectory() throws {
        // Given
        let key = "file"
        let data = "valid data".data(using: .utf8) ?? Data()
        mockFileManager.stubbedFileExistsResult = true

        // When
        try sut.save(value: data, for: key)

        XCTAssertEqual(mockFileManager.invokedFileExistsCount, 1)
        XCTAssertFalse(mockFileManager.invokedCreateDirectory)
    }

    func test_save_withNonExistingFile_shouldCreateDirectory() throws {
        // Given
        let key = "file"
        let data = "valid data".data(using: .utf8) ?? Data()
        mockFileManager.stubbedFileExistsResult = false

        // When
        try sut.save(value: data, for: key)

        XCTAssertEqual(mockFileManager.invokedFileExistsCount, 1)
        XCTAssertEqual(mockFileManager.invokedCreateDirectoryCount, 1)
    }
}
