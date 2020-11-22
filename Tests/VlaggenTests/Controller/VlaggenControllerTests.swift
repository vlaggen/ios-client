@testable import Vlaggen
import XCTest
import VlaggenNetworkModels

final class VlaggenControllerTests: XCTestCase {

    var mockMemoryStore: DefaultVlaggenMemoryStoreMock!
    var mockDiskStore: DefaultVlaggenDiskStoreMock!
    var mockRemoteStore: DefaultVlaggenRemoteStoreMock!

    var sut: VlaggenController!

    override func setUp() {
        let diskStore = DefaultVlaggenDiskStoreMock()
        diskStore.stubbedListResult = .success([])
        createSUT(diskStore: diskStore)
    }

    func createSUT(
        memoryStore: DefaultVlaggenMemoryStoreMock = DefaultVlaggenMemoryStoreMock(),
        diskStore: DefaultVlaggenDiskStoreMock,
        remoteStore: DefaultVlaggenRemoteStoreMock = DefaultVlaggenRemoteStoreMock()
    ) {
        mockMemoryStore = memoryStore
        mockDiskStore = diskStore
        mockRemoteStore = remoteStore
        sut = VlaggenController(
            memoryStore: mockMemoryStore,
            diskStore: mockDiskStore,
            remoteStore: mockRemoteStore
        )
    }

    // MARK: - Init

    func test_init() {
        // Given
        let diskStore = DefaultVlaggenDiskStoreMock()
        diskStore.stubbedListResult = .success([
            ParameterResponse(key: "key", value: .string("value")),
        ])

        // When
        createSUT(diskStore: diskStore)

        // Then
        XCTAssertEqual(mockDiskStore.invokedListCount, 1)
        XCTAssertEqual(mockMemoryStore.invokedStoreCount, 1)
        XCTAssertEqual(mockMemoryStore.invokedStoreParameters?.parameters.count, 1)
    }

    func test_init_withFailure_shouldNotStoreDiskIntoMemoryStore() {
        // Given
        let diskStore = DefaultVlaggenDiskStoreMock()
        diskStore.stubbedListResult = .failure(NSError())

        // When
        createSUT(diskStore: diskStore)

        // Then
        XCTAssertEqual(mockDiskStore.invokedListCount, 1)
        XCTAssertFalse(mockMemoryStore.invokedStore)

    }

    // MARK: - Fetch

    func test_fetch_shouldInvokeRemoteStoreList() {
        // When
        sut.fetch { _ in }

        // Then
        XCTAssertEqual(mockRemoteStore.invokedListCount, 1)
    }

    func test_fetch_withSuccess_shouldInvokeMemoryAndDiskStore() {
        // Given
        mockRemoteStore.stubbedListCompletionResult = (.success([]), Void())

        // When
        sut.fetch { _ in }

        // Then
        XCTAssertEqual(mockMemoryStore.invokedStoreCount, 2)
        XCTAssertEqual(mockDiskStore.invokedStoreCount, 1)
    }

    func test_fetch_withParameterResponses_shouldReturnParameters() {
        // Given
        mockRemoteStore.stubbedListCompletionResult = (.success([
            ParameterResponse(key: "key_1", value: .string("value")),
            ParameterResponse(key: "key_2", value: .double(1.4)),
            ParameterResponse(key: "key_3", value: .bool(true)),
        ]), Void())

        // When
        var sutResult: Result<[Parameter], Error>? = nil
        sut.fetch { (result) in
            sutResult = result
        }

        // Then
        let expected = [
            Parameter(key: "key_1", value: "value"),
            Parameter(key: "key_2", value: 1.4),
            Parameter(key: "key_3", value: true),
        ]

        switch sutResult {
            case .success(let parameters):
                XCTAssertEqual(parameters[0].key, expected[0].key)
                XCTAssertEqualType(String.self, parameters[0].value, contains: expected[0].value)

                XCTAssertEqual(parameters[1].key, expected[1].key)
                XCTAssertEqualType(Double.self, parameters[1].value, contains: expected[1].value)

                XCTAssertEqual(parameters[2].key, expected[2].key)
                XCTAssertEqualType(Bool.self, parameters[2].value, contains: expected[2].value)
            default: XCTFail()
        }
    }

    // MARK: - Get

    func test_get_withString_shouldReturnString() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .string("value"))

        // When
        let result = sut.get(key: "key", as: String.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, "value")
    }

    func test_get_withDouble_shouldReturnDouble() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .double(1.4))

        // When
        let result = sut.get(key: "key", as: Double.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, 1.4)
    }

    func test_get_withDoubleButIntValue_shouldReturnDouble() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .double(1))

        // When
        let result = sut.get(key: "key", as: Double.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, 1.0)
    }

    func test_get_withDouble_whenExpectingInt_shouldReturnNil() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .double(1.4))

        // When
        let result = sut.get(key: "key", as: Int.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertNil(result)
    }

    func test_get_withBool_when_shouldReturnBool() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .bool(true))

        // When
        let result = sut.get(key: "key", as: Bool.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertTrue(result ?? false)
    }

    func test_get_withDecodable_shouldReturnModel() throws {
        struct Model: Codable, Equatable {
            let title: String
        }

        // Given
        let custom = Model(title: "Nice")

        let encoder = JSONEncoder()
        let data = try encoder.encode(custom)
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: try ParameterValue(data: data))

        // When
        let result = sut.get(key: "key", as: Model.self)

        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, Model(title: "Nice"))
    }

    // MARK: - Get with fallback

    func test_getWithFallback_withUnknownKey_shouldReturnFallback() {
        // Given

        // When
        let result = sut.get(key: "key", as: String.self, fallback: "fallback")


        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, "fallback")
    }

    func test_getWithFallback_withNotExpectingType_shouldReturnFallback() {
        // Given
        mockMemoryStore.stubbedGetResult = ParameterResponse(key: "key", value: .double(1.4))

        // When
        let result = sut.get(key: "key", as: String.self, fallback: "fallback")


        // Then
        XCTAssertEqual(mockMemoryStore.invokedGetCount, 1)
        XCTAssertEqual(result, "fallback")
    }
}
