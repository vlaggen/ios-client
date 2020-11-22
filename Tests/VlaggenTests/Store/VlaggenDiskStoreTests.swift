@testable import Vlaggen
import XCTest
import VlaggenNetworkModels

final class VlaggenDiskStoreTests: XCTestCase {

    var mockStorage: DefaultCodableStorageMock!

    var sut: VlaggenDiskStore!

    override func setUp() {
        mockStorage = DefaultCodableStorageMock()

        sut = VlaggenDiskStore(storage: mockStorage)
    }

    // MARK: - List

    func test_list_withResponse_shouldReturnResultWithResponse() {
        // Given
        mockStorage.stubbedFetchResult = [ParameterResponse(key: "key", value: .string("value"))]

        // When
        let result = sut.list()

        // Then
        let expectedParameter = ParameterResponse(key: "key", value: .string("value"))
        XCTAssertResult(result, contains: [expectedParameter])
        XCTAssertEqual(mockStorage.invokedFetchParameters?.key, "parameters.json")
    }

    func test_list_withError_shouldReturnResultWithError() {
        // Given
        mockStorage.stubbedFetchError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Localized description"])

        // When
        let result = sut.list()

        // Then
        let expectedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Localized description"])
        XCTAssertResult(result, contains: expectedError)
        XCTAssertEqual(mockStorage.invokedFetchParameters?.key, "parameters.json")
    }

    // MARK: - Store

    func test_store_withResponse_shouldInvokeStorageSave() {
        // Given
        let parameters = [ParameterResponse(key: "key", value: .string("value"))]

        // When
        sut.store(parameters: parameters)

        // Then
        XCTAssertEqual(mockStorage.invokedSaveCount, 1)
        XCTAssertEqual(mockStorage.invokedSaveParameters?.key, "parameters.json")
        XCTAssertEqual(mockStorage.invokedSaveParameters?.value as? [ParameterResponse], parameters)
    }

    func test_store_withError_shouldInvokeStorageSaveAndThrowError() {
        // Given
        let parameters = [ParameterResponse(key: "key", value: .string("value"))]

        mockStorage.stubbedSaveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Localized description"])

        // When
        sut.store(parameters: parameters)

        // Then
        XCTAssertEqual(mockStorage.invokedSaveCount, 1)
        XCTAssertEqual(mockStorage.invokedSaveParameters?.key, "parameters.json")
        XCTAssertEqual(mockStorage.invokedSaveParameters?.value as? [ParameterResponse], parameters)
        XCTAssertEqual(mockStorage.stubbedSaveError?.localizedDescription, "Localized description")
    }
}
