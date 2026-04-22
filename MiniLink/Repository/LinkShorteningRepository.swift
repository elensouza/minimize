import Foundation

protocol LinkShorteningRepositoryProtocol {
    func shorten(url: String) async throws -> ShortenedLinkViewObject
}

final class LinkShorteningRepository: LinkShorteningRepositoryProtocol {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func shorten(url: String) async throws -> ShortenedLinkViewObject {
        let payload = ShortenLinkPayload(url: url)
        let endpoint = ShorteningLinkEndpoint.short(payload: payload)
        let response: ShortenLinkResponse = try await client.request(endpoint)

        return ShortenedLinkViewObject(
            id: response.alias,
            originalURL: response.links.original,
            shortURL: response.links.short
        )
    }
}
