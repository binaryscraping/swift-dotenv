import XCTest

@testable import DotEnv

final class DotEnvTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(DotEnv().text, "Hello, World!")
  }
}