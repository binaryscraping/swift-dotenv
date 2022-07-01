import PackagePlugin

@main
struct DotEnvPlugin: BuildToolPlugin {
  func createBuildCommands(
    context: PluginContext,
    target: Target
  ) async throws -> [Command] {
    return []
  }
}
