@testable import Vlaggen
import XCTest
import VlaggenNetworkModels

final class CodableStorageTests: XCTestCase {

    var mockStorage: DefaultStorageMock!

    var sut: CodableStorage!

    override func setUp() {
        mockStorage = DefaultStorageMock()

        sut = CodableStorage(storage: mockStorage)
    }

    // MARK: - Fetch

    func test_fetch_shouldInvokeStorageGet() throws {
        // Given
        let model = CodableStorageModel(title: "Nice")

        let data = try JSONEncoder().encode(model)
        mockStorage.stubbedGetResult = data

        // When
        let _: CodableStorageModel = try sut.fetch(for: "key")

        // Then
        XCTAssertEqual(mockStorage.invokedGetCount, 1)
        XCTAssertEqual(mockStorage.invokedGetParameters?.key, "key")
    }

    func test_fetch_shouldReturnModel() throws {
        // Given
        let model = CodableStorageModel(title: "Nice")

        let data = try JSONEncoder().encode(model)
        mockStorage.stubbedGetResult = data

        // When
        let result: CodableStorageModel = try sut.fetch(for: "key")

        // Then
        XCTAssertEqual(result, model)
    }

    // MARK: - Store

    func test_store_shouldInvokeStorageSave() throws {
        // Given
        let model = CodableStorageModel(title: "Nice")

        // When
        try sut.save(model, for: "key")

        // Then
        XCTAssertEqual(mockStorage.invokedSaveCount, 1)
        XCTAssertEqual(mockStorage.invokedSaveParameters?.key, "key")
    }

    func test_store_shouldStoreModel() throws {
        // Given
        let model = CodableStorageModel(title: "Nice")

        // When
        try sut.save(model, for: "key")

        // Then
        let expectedData = try JSONEncoder().encode(model)
        XCTAssertEqual(mockStorage.invokedSaveParameters?.key, "key")
        XCTAssertEqual(mockStorage.invokedSaveParameters?.value, expectedData)
    }

    struct CodableStorageModel: Codable, Equatable {
        let title: String
    }
}
