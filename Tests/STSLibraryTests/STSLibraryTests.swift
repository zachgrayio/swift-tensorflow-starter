import XCTest
@testable import STSLibrary

final class STSLibraryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Application().message, "STS: Hello, world!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
