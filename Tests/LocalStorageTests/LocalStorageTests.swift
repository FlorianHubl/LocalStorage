import XCTest
@testable import LocalStorage

final class LocalStorageTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LocalStorage().text, "Hello, World!")
    }
}
