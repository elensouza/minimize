import Foundation

final class UITestingNetworkClient: NetworkClient, @unchecked Sendable {
    private let stubbedResponse: Decodable?
    private let stubbedError: Error?
    private let delay: TimeInterval

    init() {
        let env = ProcessInfo.processInfo.environment

        delay = env["REPOSITORY_DELAY"].flatMap(Double.init) ?? 0.1

        if env["TEST_SCENARIO"] == "ERROR" {
            stubbedError = URLError(.badServerResponse)
            stubbedResponse = nil
        } else {
            stubbedError = nil
            stubbedResponse = ShortenLinkResponse(
                alias: "uitest123",
                links: ShortenLinkResponse.Links(
                    original: "https://example.com",
                    short: "https://short.ly/uitest123"
                )
            )
        }
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

        if let error = stubbedError {
            throw error
        }

        guard let response = stubbedResponse as? T else {
            throw URLError(.cannotParseResponse)
        }

        return response
    }
}
