import Foundation
import Observation

@MainActor
@Observable
final class LinkShortenerViewModel {
    struct State {
        var input: String = ""
        var items: [ShortenedLinkViewObject] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case updateInput(String)
        case shortenTapped
        case clearError
    }

    var state = State()

    private let repository: LinkShorteningRepositoryProtocol

    init(repository: LinkShorteningRepositoryProtocol) {
        self.repository = repository
    }

    func send(_ action: Action) {
        switch action {
        case .updateInput(let text):
            state.input = text
            state.errorMessage = nil

        case .shortenTapped:
            shorten()

        case .clearError:
            state.errorMessage = nil
        }
    }
}

private extension LinkShortenerViewModel {
    func shorten() {
        let url = state.input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidURL(url) else {
            state.errorMessage = Strings.errorInvalidLinkKey
            return
        }

        state.isLoading = true
        state.errorMessage = nil

        Task {
            defer { state.isLoading = false }

            do {
                let result = try await repository.shorten(url: url)

                state.items.insert(result, at: 0)
                state.input = ""
            } catch let urlError as URLError where urlError.code == .timedOut {
                state.errorMessage = Strings.errorTimeoutKey
            } catch {
                state.errorMessage = Strings.errorGenericKey
            }
        }
    }

    func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              url.host != nil
        else {
            return false
        }
        return true
    }
}
