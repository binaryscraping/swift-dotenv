import ArgumentParser
import DotEnvCore
import Foundation

struct DotEnv: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "swift-dotenv"
  )

  @Argument(help: ".env file to process.")
  var inputFile: String

  @Argument(help: "Output destination.")
  var outputFile: String

  @Option(help: "Name of enum wrapping the properties.")
  var namespace = "DotEnv"

  @Flag(help: "Whenever the generated code can be public accessed or not.")
  var publicAccess = false

  func run() throws {
    let inputURL: URL

    if #available(macOS 13.0, *) {
      inputURL = URL(filePath: inputFile)
    } else {
      inputURL = URL(fileURLWithPath: inputFile)
    }

    let result = try DotEnvCore.DotEnv.load(from: inputURL)

    let access = publicAccess ? "public " : ""

    var generatedCode = """
      \(access)enum \(namespace) {\n
      """

    for config in result.entries {
      generatedCode.append(
        "  \(access)static let \(config.key) = \"\(config.value)\"\n"
      )
    }

    generatedCode.append("}")

    let output = generatedCode.data(using: .utf8) ?? Data()

    if #available(macOS 13.0, *) {
      try output.write(to: URL(filePath: outputFile))
    } else {
      try output.write(to: URL(fileURLWithPath: outputFile))
    }
  }

  func parse(_ input: String) -> [(key: String, value: String)] {
    var configs: [(key: String, value: String)] = []
    let lines = input.split(separator: "\n")

    for line in lines {
      let components =
        line
        .split(separator: "=")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      assert(components.count == 2)
      configs.append((key: components[0], value: components[1]))
    }

    return configs
  }
}

DotEnv.main()
