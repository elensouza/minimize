import SwiftUI
import Observation

struct LinkShortenerView: View {
    @State var viewModel: LinkShortenerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(spacing: Spacing.small) {
                TextField(
                    Strings.enterURLPlaceholder,
                    text: Binding(
                        get: { viewModel.state.input },
                        set: { viewModel.send(.updateInput($0)) }
                    )
                )
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("urlTextField")

                Button {
                    viewModel.send(.shortenTapped)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 44, height: 44)
                }
                .background(AppColors.primary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: Radius.medium))
                .disabled(viewModel.state.input.isEmpty || viewModel.state.isLoading)
                .accessibilityIdentifier("shortenButton")
            }

            if viewModel.state.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }

            if !viewModel.state.items.isEmpty {
                Text("Recently shortened URLs")
                    .font(.headline)
                    .padding(.top, Spacing.small)
            }

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.state.items) { item in
                        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                            Text(item.shortURL)
                                .font(.headline)

                            Text(item.originalURL)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, Spacing.large)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("shortenedItem")
                        .accessibilityElement(children: .combine)

                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(AppColors.background)
        .alert(
            Strings.alertErrorTitle,
            isPresented: Binding(
                get: { viewModel.state.errorMessage != nil },
                set: { _ in viewModel.send(.clearError) }
            )
        ) {
            Button(Strings.alertOK, role: .cancel) { }
        } message: {
            Text(viewModel.state.errorMessage ?? "")
        }
    }
}

#Preview("Empty") {
    LinkShortenerView(viewModel: makeLinkShortenerPreviewViewModel())
}

#Preview("Loading") {
    LinkShortenerView(viewModel: makeLinkShortenerPreviewViewModel(isLoading: true))
}

#Preview("Success Items") {
    LinkShortenerView(viewModel: makeLinkShortenerPreviewViewModel(items: [
        ShortenedLinkViewObject(id: "1", originalURL: "https://example.com", shortURL: "https://short.ly/1"),
        ShortenedLinkViewObject(id: "2", originalURL: "https://apple.com", shortURL: "https://short.ly/2")
    ]))
}

#Preview("Invalid URL Error") {
    LinkShortenerView(viewModel: makeLinkShortenerPreviewViewModel(error: Strings.errorInvalidLinkKey))
}

#Preview("Generic Error") {
    LinkShortenerView(viewModel: makeLinkShortenerPreviewViewModel(error: Strings.errorGenericKey))
}
