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

    let config = try DotEnvCore.DotEnv.load(from: inputURL)

    let outputURL: URL

    if #available(macOS 13.0, *) {
      outputURL = URL(filePath: outputFile)
    } else {
      outputURL = URL(fileURLWithPath: outputFile)
    }

    let generator = CodeGenerator(
      configuration: config, namespace: namespace, publicAccess: publicAccess)
    try generator.write(to: outputURL)
  }
}

DotEnv.main()
