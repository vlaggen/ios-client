@testable import Vlaggen
import XCTest
import VlaggenNetworking
import VlaggenNetworkModels
import Moya

final class VlaggenRemoteStoreTests: XCTestCase {

    var mockClient: DefaultParameterAsyncNetworkableMock!

    var sut: VlaggenRemoteStore!

    override func setUp() {
        mockClient = DefaultParameterAsyncNetworkableMock()

        sut = VlaggenRemoteStore(client: mockClient)
    }

    func test_list_withParameters_shouldReturnResultSuccess() {
        // Given
        let parameters = [ParameterResponse(key: "key", value: .string("value"))]
        mockClient.stubbedListCompletionResult = (.success(parameters), Void())

        // When
        sut.list { (result) in
            // Then
            XCTAssertResult(result, contains: parameters)
        }
    }

    func test_list_withError_shouldReturnResultFailure() {
        // Given
        mockClient.stubbedListCompletionResult = (.failure(.requestMapping("error")), Void())

        // When
        sut.list { (result) in
            // Then
            XCTAssertResult(result, contains: MoyaError.requestMapping("error"))
        }
    }
}
