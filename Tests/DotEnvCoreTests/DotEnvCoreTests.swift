import CustomDump
import XCTest

@testable import DotEnvCore

final class DotEnvTests: XCTestCase {
  let input = """
    SUPABASE_URL=http://localhost:3000
    SUPABASE_ANON_KEY=abc.def.ghi
    """

  func testParse() throws {
    let config = try DotEnv.parse(from: input)

    XCTAssertNoDifference(
      config,
      DotEnv.Configuration(
        entries: [
          .init(key: "SUPABASE_URL", value: "http://localhost:3000"),
          .init(key: "SUPABASE_ANON_KEY", value: "abc.def.ghi"),
        ]
      )
    )
  }

  func testGenerate() throws {
    let config = try DotEnv.parse(from: input)
    let generator = CodeGenerator(
      configuration: config,
      namespace: "MyNamespace",
      publicAccess: false
    )

    let code = generator.generate()

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
    let config = try DotEnv.parse(from: input)
    let generator = CodeGenerator(
      configuration: config,
      namespace: "DotEnv",
      publicAccess: true
    )

    let code = generator.generate()

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
