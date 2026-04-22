import SwiftUI

@main
struct MiniLinkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LinkShortenerFactory.make(client: resolveNetworkClient())
        }
    }

    private func resolveNetworkClient() -> NetworkClient {
        if ProcessInfo.processInfo.arguments.contains("UITesting") {
            return UITestingNetworkClient()
        }
        return DefaultNetworkClient()
    }
}
