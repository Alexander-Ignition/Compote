import XCTest
@testable import Compote

final class CompoteTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Compote().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
