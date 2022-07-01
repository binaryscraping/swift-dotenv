import Foundation

public struct Configuration: Equatable {
  public struct Entry: Equatable {
    public let key: String
    public let value: String

    public init(key: String, value: String) {
      self.key = key
      self.value = value
    }
  }

  public let entries: [Entry]

  public init(_ entries: [Entry]) {
    self.entries = entries
  }
}

public struct DotEnvParser {
  public init() {}

  public func parse(fromContentsOf url: URL) throws -> Configuration {
    let contents = try String(contentsOf: url)
    return try parse(from: contents)
  }

  public func parse(from contents: String) throws -> Configuration {
    var entries: [Configuration.Entry] = []
    let lines = contents.split(separator: "\n")

    for (idx, line) in zip(lines.indices, lines) {
      let components =
        line
        .split(separator: "=")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

      if components.count != 2 {
        throw ParserError.unexpectedEntry(position: idx + 1, contents: String(line))
      }

      entries.append(.init(key: components[0], value: components[1]))
    }

    return Configuration(entries)
  }
}

public enum ParserError: Error {
  case unexpectedEntry(position: Int, contents: String)
}
