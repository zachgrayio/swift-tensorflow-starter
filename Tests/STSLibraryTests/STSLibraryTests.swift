import XCTest
@testable import STSLibrary

final class STSLibraryTests: XCTestCase {

    func testApplicationPrefix() {
        XCTAssertEqual(Application().prefix, "STS")
    }

    static var allTests = [
        ("testApplicationPrefix", testApplicationPrefix),
    ]
}
