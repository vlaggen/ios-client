import XCTest

func XCTAssertResult<T: Equatable, E: Error>(_ result: Result<T, E>?, contains expectedError: Error, in file: StaticString = #file, line: UInt = #line) {
    switch result {
        case .success:
            XCTFail("No error thrown", file: file, line: line)
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription, file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
    }
}

func XCTAssertResult<T: Equatable, E: Error>(_ result: Result<T, E>?, contains expectedObject: T, in file: StaticString = #file, line: UInt = #line) {
    switch result {
        case .success(let object):
            XCTAssertEqual(object, expectedObject, file: file, line: line)
        case .failure(let error):
            XCTFail("An error was thrown: \(error)", file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
    }
}
