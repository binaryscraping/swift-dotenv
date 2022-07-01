import Foundation

public struct CodeGenerator {

  public struct Options {
    let namespace: String
    let publicAccess: Bool

    public init(namespace: String, publicAccess: Bool) {
      self.namespace = namespace
      self.publicAccess = publicAccess
    }
  }

  let configuration: DotEnv.Configuration

  public init(configuration: DotEnv.Configuration) {
    self.configuration = configuration
  }

  public func generate(options: Options) -> String {
    let access = options.publicAccess ? "public " : ""

    var generatedCode = """
      \(access)enum \(options.namespace) {\n
      """

    for config in configuration.entries {
      generatedCode.append(
        "  \(access)static let \(config.key) = \"\(config.value)\"\n"
      )
    }

    generatedCode.append("}")
    return generatedCode
  }

  public func write(to url: URL, with options: Options) throws {
    let data = generate(options: options).data(using: .utf8) ?? Data()
    try data.write(to: url)
  }
}
