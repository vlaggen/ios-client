import XCTest

extension XCTestCase {
    func XCTAssertEqualType<T: Equatable>(_ valueType: T.Type, _ value: Any?, contains expectedObject: Any?, in file: StaticString = #file, line: UInt = #line) {
        guard let typeValue = value as? T else {
            return XCTFail("Value was not of type \(valueType) but type \(type(of: value))", file: file, line: line)
        }

        guard let typeExpectedObject = expectedObject as? T else {
            return XCTFail("Expected object was not of type \(valueType) but type \(type(of: expectedObject))", file: file, line: line)
        }

        XCTAssertEqual(typeValue, typeExpectedObject)
    }
}
