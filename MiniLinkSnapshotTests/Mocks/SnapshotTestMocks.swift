import SwiftUI
import SnapshotTesting
@testable import MiniLink

enum SnapshotTestError: Error {
    case stubTypeMismatch
}

final class SnapshotMockLinkShorteningRepository: LinkShorteningRepositoryProtocol, @unchecked Sendable {
    var stubbedResult: ShortenedLinkViewObject?
    var stubbedError: Error?

    func shorten(url: String) async throws -> ShortenedLinkViewObject {
        try await Task.sleep(nanoseconds: 1_000_000)
        if let error = stubbedError { throw error }
        guard let result = stubbedResult else { throw SnapshotTestError.stubTypeMismatch }
        return result
    }
}

@MainActor
func makeMockLinkShortenerViewModel(
    input: String = "",
    items: [ShortenedLinkViewObject] = [],
    isLoading: Bool = false,
    error: String? = nil
) -> LinkShortenerViewModel {
    let repository = SnapshotMockLinkShorteningRepository()
    let viewModel = LinkShortenerViewModel(repository: repository)
    viewModel.state.input = input
    viewModel.state.items = items
    viewModel.state.isLoading = isLoading
    viewModel.state.errorMessage = error
    return viewModel
}
