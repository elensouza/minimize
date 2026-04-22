import Foundation
import Testing
@testable import MiniLink

struct NetworkClientTests {
    @Test
    func requestDecodesResponseCorrectly() async throws {
        let mockClient = MockNetworkClient()
        let expectedResponse = ShortenLinkResponse(alias: "test", links: .init(original: "orig", short: "short"))
        mockClient.stubbedResponse = expectedResponse

        let endpoint = ShorteningLinkEndpoint.short(payload: .init(url: "test"))
        let result: ShortenLinkResponse = try await mockClient.request(endpoint)

        #expect(result.alias == "test")
        #expect(result.links.original == "orig")
        #expect(result.links.short == "short")
    }

    @Test
    func requestThrowsErrorWhenStubbed() async throws {
        let mockClient = MockNetworkClient()
        mockClient.stubbedError = URLError(.notConnectedToInternet)

        let endpoint = ShorteningLinkEndpoint.short(payload: .init(url: "test"))

        await #expect(throws: URLError.self) {
            let _: ShortenLinkResponse = try await mockClient.request(endpoint)
        }
    }

    @Test
    func requestThrowsTypeMismatch() async throws {
        let mockClient = MockNetworkClient()
        mockClient.stubbedResponse = "invalid type"

        let endpoint = ShorteningLinkEndpoint.short(payload: .init(url: "test"))

        await #expect(throws: TestError.self) {
            let _: ShortenLinkResponse = try await mockClient.request(endpoint)
        }
    }
}