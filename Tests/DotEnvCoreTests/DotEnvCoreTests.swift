import CustomDump
import XCTest

@testable import DotEnvCore

final class DotEnvTests: XCTestCase {
  let input = """
    SUPABASE_URL=http://localhost:3000
    SUPABASE_ANON_KEY=abc.def.ghi
    """

  let malformedInput = """
    SUPABASE_URL=http://localhost=:3000
    SUPABASE_ANON_KEY=abc.def.ghi
    """

  func testParse() throws {
    let config = try DotEnvParser().parse(from: input)

    XCTAssertNoDifference(
      config,
      .init(
        [
          .init(key: "SUPABASE_URL", value: "http://localhost:3000"),
          .init(key: "SUPABASE_ANON_KEY", value: "abc.def.ghi"),
        ]
      )
    )
  }

  func testParseWithMalformedFile() {
    do {
      _ = try DotEnvParser().parse(from: malformedInput)
      XCTFail("Test should fail")
    } catch let ParserError.unexpectedEntry(position, contents) {
      XCTAssertEqual(position, 1)
      XCTAssertEqual(contents, "SUPABASE_URL=http://localhost=:3000")
    } catch {
      XCTFail("Test failed with unexpected error: \(error.localizedDescription)")
    }
  }

  func testGenerate() throws {
    let config = try DotEnvParser().parse(from: input)
    let generator = CodeGenerator(configuration: config)

    let code = generator.generate(
      options: .init(
        namespace: "MyNamespace",
        publicAccess: false
      )
    )

    XCTAssertNoDifference(
      code,
      """
      enum MyNamespace {
        static let SUPABASE_URL = "http://localhost:3000"
        static let SUPABASE_ANON_KEY = "abc.def.ghi"
      }
      """
    )
  }

  func testGeneratePublic() throws {
    let config = try DotEnvParser().parse(from: input)
    let generator = CodeGenerator(configuration: config)

    let code = generator.generate(
      options: .init(
        namespace: "DotEnv",
        publicAccess: true
      )
    )

    XCTAssertNoDifference(
      code,
      """
      public enum DotEnv {
        public static let SUPABASE_URL = "http://localhost:3000"
        public static let SUPABASE_ANON_KEY = "abc.def.ghi"
      }
      """
    )
  }
}
