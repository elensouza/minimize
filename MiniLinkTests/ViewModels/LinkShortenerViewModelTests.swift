import Foundation
import Testing
@testable import MiniLink

@MainActor
struct LinkShortenerViewModelTests {
    @Test
    func handlesValidURLInputCorrectly() async throws {
        let expected = ShortenedLinkViewObject(
            id: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        let repository = MockLinkShorteningRepository()
        repository.stubbedResult = expected
        let sut = LinkShortenerViewModel(repository: repository)

        sut.send(.updateInput("https://example.com"))
        sut.send(.shortenTapped)

        while sut.state.isLoading {
            await Task.yield()
        }

        #expect(sut.state.items.count == 1)
        let item = try #require(sut.state.items.first)
        #expect(item.id == expected.id)
        #expect(item.originalURL == expected.originalURL)
        #expect(item.shortURL == expected.shortURL)
    }

    @Test
    func handlesInvalidURLInput() async throws {
        let repository = MockLinkShorteningRepository()
        let sut = LinkShortenerViewModel(repository: repository)

        sut.send(.updateInput("invalid-url"))
        sut.send(.shortenTapped)

        #expect(sut.state.errorMessage == Strings.errorInvalidLinkKey)
        #expect(sut.state.items.isEmpty)
    }

    @Test
    func handlesAPIError() async throws {
        let repository = MockLinkShorteningRepository()
        repository.stubbedError = URLError(.badServerResponse)
        let sut = LinkShortenerViewModel(repository: repository)

        sut.send(.updateInput("https://example.com"))
        sut.send(.shortenTapped)

        while sut.state.isLoading {
            await Task.yield()
        }

        #expect(sut.state.errorMessage == Strings.errorGenericKey)
        #expect(sut.state.items.isEmpty)
    }

    @Test
    func clearsErrorOnInputUpdate() async throws {
        let repository = MockLinkShorteningRepository()
        let sut = LinkShortenerViewModel(repository: repository)

        sut.send(.updateInput("invalid"))
        sut.send(.shortenTapped)
        #expect(sut.state.errorMessage != nil)

        sut.send(.updateInput("valid"))
        #expect(sut.state.errorMessage == nil)
    }

    @Test
    func loadingStateDuringShortening() async throws {
        let repository = MockLinkShorteningRepository()
        repository.stubbedResult = ShortenedLinkViewObject(id: "1", originalURL: "https://test.com", shortURL: "short")
        let sut = LinkShortenerViewModel(repository: repository)

        sut.send(.updateInput("https://test.com"))
        sut.send(.shortenTapped)

        #expect(sut.state.isLoading == true)

        while sut.state.isLoading {
            await Task.yield()
        }

        #expect(sut.state.isLoading == false)
    }
}
