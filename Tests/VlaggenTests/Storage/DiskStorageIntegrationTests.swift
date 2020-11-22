@testable import Vlaggen
import XCTest

private enum Constants {
    static let fileKey = "key of file.txt"
    static let anotherFileKey = "another file.txt"
    static let fileFolderKey = "files"
    static let fileWithFolderKey = "files/file.txt"
}

final class DiskStorageIntegrationTests: XCTestCase {

    var mockURL: URL!

    var sut: DiskStorage!

    override func setUp() {
        mockURL = URL(fileURLWithPath: NSTemporaryDirectory())

        sut = DiskStorage(path: mockURL)
    }

    override func tearDownWithError() throws {
        try [
            Constants.fileKey,
            Constants.anotherFileKey,
            Constants.fileFolderKey,
            Constants.fileWithFolderKey,
        ].forEach { (key) in
            try tearDown(at: key)
        }
    }

    func tearDown(at fileKey: String) throws {
        let fileURL = mockURL.appendingPathComponent(fileKey)
        let filePath = fileURL.path
        if FileManager.default.fileExists(atPath: filePath) {
            try FileManager.default.removeItem(atPath: filePath)
        }
    }

    // MARK: - Get

    func test_get_withUnknownFile_shouldThrowNotFoundError() throws {
        // Given
        let key = Constants.fileKey

        // When
        XCTAssertThrowsError(try sut.get(for: key)) { (error) in
            guard case StorageError.notFound = error else {
                return XCTFail()
            }
        }

        // Then
        let expectedURL = mockURL.appendingPathComponent(key)
        XCTAssertFalse(FileManager.default.fileExists(atPath: expectedURL.absoluteString))
    }

    func test_get_withFile_shouldReturnData() throws {
        // Given
        let key = Constants.fileKey
        let data = "valid data".data(using: .utf8) ?? Data()
        try sut.save(value: data, for: key)

        // When
        let result = try sut.get(for: key)

        // Then
        let expectedURL = mockURL.appendingPathComponent(key)
        let expectedData = "valid data".data(using: .utf8)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedURL.path))
        XCTAssertEqual(result, expectedData)
    }

    // MARK: - Save

    func test_save_withData_shouldWriteDataToDisk() throws {
        // Given
        let key = Constants.fileKey
        let data = "valid data".data(using: .utf8) ?? Data()

        // When
        try sut.save(value: data, for: key)

        // Then
        let expectedURL = mockURL.appendingPathComponent(key)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedURL.path))
    }

    func test_save_withDataTwice_shouldOverwriteData() throws {
        // Given
        let key = Constants.fileKey
        let data = "valid data".data(using: .utf8) ?? Data()
        try sut.save(value: data, for: key)

        let newData = "new data".data(using: .utf8) ?? Data()

        // When
        try sut.save(value: newData, for: key)

        // Then
        let expectedURL = mockURL.appendingPathComponent(key)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedURL.path))

        let result = FileManager.default.contents(atPath: expectedURL.path)
        XCTAssertEqual(result, newData)
    }

    func test_save_withFolderSameNameAsFile_shouldThrowWriteError() throws {
        // Given
        let data = "valid data".data(using: .utf8) ?? Data()
        try sut.save(value: data, for: Constants.fileFolderKey)

        // When
        XCTAssertThrowsError(try sut.save(value: data, for: Constants.fileWithFolderKey)) { (error) in

            // Then
            guard case StorageError.write = error else {
                return XCTFail()
            }
        }
    }

    func test_save_withFileSameNameAsFolder_shouldThrowWriteError() throws {
        // Given
        let data = "valid data".data(using: .utf8) ?? Data()
        try sut.save(value: data, for: Constants.fileWithFolderKey)

        // When
        XCTAssertThrowsError(try sut.save(value: data, for: Constants.fileFolderKey)) { (error) in

            // Then
            guard case StorageError.write = error else {
                return XCTFail()
            }
        }
    }

    func test_save_withFolder_shouldWriteDataToDisk() throws {
        // Given
        let key = Constants.fileWithFolderKey
        let data = "valid data".data(using: .utf8) ?? Data()

        // When
        try sut.save(value: data, for: key)

        // Then
        let expectedURL = mockURL.appendingPathComponent(key)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedURL.path))
    }

    func test_save_withMutlipleFiles_shouldWriteFilesToDisk() throws {
        // Given
        let fileKey = Constants.fileKey
        let anotherFileKey = Constants.anotherFileKey
        let data = "valid data".data(using: .utf8) ?? Data()

        // When
        try sut.save(value: data, for: fileKey)
        try sut.save(value: data, for: anotherFileKey)

        // Then
        let expectedFileURL = mockURL.appendingPathComponent(fileKey)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedFileURL.path))

        let expectedAnotherFileURL = mockURL.appendingPathComponent(anotherFileKey)
        XCTAssertTrue(FileManager.default.fileExists(atPath: expectedAnotherFileURL.path))
    }
}
