import Foundation

public enum DotEnv {
  public struct Configuration {
    public struct Entry {
      public let key: String
      public let value: String
    }

    public let entries: [Entry]
  }

  public static func load(from url: URL) throws -> Configuration {
    let contents = try String(contentsOf: url)
    var entries: [Configuration.Entry] = []
    let lines = contents.split(separator: "\n")

    for (idx, line) in zip(lines.indices, lines) {
      let components =
        line
        .split(separator: "=")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

      if components.count != 2 {
        throw UnexpectedEntryError(line: String(line), location: idx + 1)
      }

      entries.append(.init(key: components[0], value: components[1]))
    }

    return Configuration(entries: entries)
  }
}

struct UnexpectedEntryError: Error {
  let line: String
  let location: Int
}
