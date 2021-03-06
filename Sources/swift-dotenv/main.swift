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
    let inputURL = URL(fileURLWithPath: inputFile)
    let outputURL = URL(fileURLWithPath: outputFile)

    let parser = DotEnvParser()
    let config = try parser.parse(fromContentsOf: inputURL)
    let generator = CodeGenerator(configuration: config)

    try generator.write(
      to: outputURL, with: .init(namespace: namespace, publicAccess: publicAccess))
  }
}

DotEnv.main()
