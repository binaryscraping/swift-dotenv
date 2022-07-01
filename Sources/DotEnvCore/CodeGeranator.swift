import Foundation

public struct CodeGenerator {

  let configuration: DotEnv.Configuration
  let namespace: String
  let publicAccess: Bool

  public init(
    configuration: DotEnv.Configuration,
    namespace: String,
    publicAccess: Bool
  ) {
    self.configuration = configuration
    self.namespace = namespace
    self.publicAccess = publicAccess
  }

  public func generate() -> String {
    let access = publicAccess ? "public " : ""

    var generatedCode = """
      \(access)enum \(namespace) {\n
      """

    for config in configuration.entries {
      generatedCode.append(
        "  \(access)static let \(config.key) = \"\(config.value)\"\n"
      )
    }

    generatedCode.append("}")
    return generatedCode
  }

  public func write(to url: URL) throws {
    let data = generate().data(using: .utf8) ?? Data()
    try data.write(to: url)
  }
}
