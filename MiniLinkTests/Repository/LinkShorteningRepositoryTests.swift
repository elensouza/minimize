import Foundation
import Testing
@testable import MiniLink

struct LinkShorteningRepositoryTests {
    @Test
    func shortenReturnsCorrectViewObject() async throws {
        let mockClient = MockNetworkClient()
        let response = ShortenLinkResponse(alias: "alias123", links: .init(original: "https://original.com", short: "https://short.com"))
        mockClient.stubbedResponse = response

        let repository = LinkShorteningRepository(client: mockClient)
        let result = try await repository.shorten(url: "https://original.com")

        #expect(result.id == "alias123")
        #expect(result.originalURL == "https://original.com")
        #expect(result.shortURL == "https://short.com")
    }

    @Test
    func shortenThrowsErrorFromClient() async throws {
        let mockClient = MockNetworkClient()
        mockClient.stubbedError = URLError(.badServerResponse)

        let repository = LinkShorteningRepository(client: mockClient)

        await #expect(throws: URLError.self) {
            _ = try await repository.shorten(url: "https://test.com")
        }
    }
}