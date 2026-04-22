import SwiftUI

private final class LinkShortenerPreviewRepository: LinkShorteningRepositoryProtocol {
    var result: ShortenedLinkViewObject?
    var error: Error?

    func shorten(url: String) async throws -> ShortenedLinkViewObject {
        if let error = error { throw error }
        guard let result = result else {
            return ShortenedLinkViewObject(id: "preview", originalURL: url, shortURL: "https://short.ly/preview")
        }
        return result
    }
}

@MainActor
func makeLinkShortenerPreviewViewModel(
    input: String = "",
    items: [ShortenedLinkViewObject] = [],
    isLoading: Bool = false,
    error: String? = nil
) -> LinkShortenerViewModel {
    let repository = LinkShortenerPreviewRepository()
    let viewModel = LinkShortenerViewModel(repository: repository)
    viewModel.state.input = input
    viewModel.state.items = items
    viewModel.state.isLoading = isLoading
    viewModel.state.errorMessage = error
    return viewModel
}
