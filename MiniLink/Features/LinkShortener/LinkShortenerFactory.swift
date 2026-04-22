import SwiftUI

enum LinkShortenerFactory {
    @MainActor
    static func make(client: NetworkClient) -> some View {
        let repository = LinkShorteningRepository(client: client)
        let viewModel = LinkShortenerViewModel(repository: repository)

        return LinkShortenerView(viewModel: viewModel)
    }
}
