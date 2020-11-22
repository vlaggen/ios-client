@testable import Vlaggen
import XCTest
import VlaggenNetworkModels

final class VlaggenMemoryStoreTests: XCTestCase {

    var sut: VlaggenMemoryStore!

    override func setUp() {
        sut = VlaggenMemoryStore()
    }

    func test_get_withParameters_shouldReturnResult() {
        // Given
        let parameters = [ParameterResponse(key: "key", value: .string("value"))]
        sut.store(parameters: parameters)

        // When
        let result = sut.get(key: "key")

        // Then
        XCTAssertEqual(result?.key, "key")
        XCTAssertEqual(result?.value, .string("value"))
    }

    func test_get_withParametersButUnknownKey_shouldReturnNil() {
        // Given
        let parameters = [ParameterResponse(key: "key", value: .string("value"))]
        sut.store(parameters: parameters)

        // When
        let result = sut.get(key: "key_unknown")

        // Then
        XCTAssertNil(result)
    }

    func test_get_withoutParameters_shouldReturnNil() {
        // When
        let result = sut.get(key: "key")

        // Then
        XCTAssertNil(result)
    }
}
