import ArgumentParser
import Dispatch
import SwiftUI
import Registry

struct Pull: AsyncParsableCommand {
  static var configuration = CommandConfiguration(abstract: "Pull a VM from a registry")

  @Argument(help: "remote VM name")
  var remoteName: String

  func run() async throws {
    do {
      // Be more liberal when accepting local image as argument,
      // see https://github.com/cirruslabs/tart/issues/36
      if VMStorageLocal().exists(remoteName) {
        print("\"\(remoteName)\" is a local image, nothing to pull here!")

        Foundation.exit(0)
      }

      let remoteName = try RemoteName(remoteName)
      let registry = try Registry(host: remoteName.host, namespace: remoteName.namespace)

      defaultLogger.appendNewLine("pulling \(remoteName)...")

      try await VMStorageOCI().pull(remoteName, registry: registry)

      Foundation.exit(0)
    } catch {
      print(error)

      Foundation.exit(1)
    }
  }
}
