import Testing
import SwiftUI
import SnapshotTesting
@testable import MiniLink

@MainActor
struct LinkShortenerViewSnapshotTests {
    @Test("LinkShortenerView - Empty State")
    func testLinkShortenerViewEmptyState() {
        let viewModel = makeMockLinkShortenerViewModel()
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - With Input")
    func testLinkShortenerViewWithInput() {
        let viewModel = makeMockLinkShortenerViewModel(input: "https://example.com")
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - Loading State")
    func testLinkShortenerViewLoadingState() {
        let viewModel = makeMockLinkShortenerViewModel(isLoading: true)
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - Single Item")
    func testLinkShortenerViewSingleItem() {
        let items = [
            ShortenedLinkViewObject(
                id: "1",
                originalURL: "https://www.example.com/very/long/url/path",
                shortURL: "https://short.ly/abc123"
            )
        ]
        let viewModel = makeMockLinkShortenerViewModel(items: items)
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - Multiple Items")
    func testLinkShortenerViewMultipleItems() {
        let items = [
            ShortenedLinkViewObject(
                id: "1",
                originalURL: "https://www.example.com/path1",
                shortURL: "https://short.ly/abc123"
            ),
            ShortenedLinkViewObject(
                id: "2",
                originalURL: "https://www.apple.com/products",
                shortURL: "https://short.ly/def456"
            ),
            ShortenedLinkViewObject(
                id: "3",
                originalURL: "https://github.com/user/repo",
                shortURL: "https://short.ly/ghi789"
            )
        ]
        let viewModel = makeMockLinkShortenerViewModel(items: items)
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - With Error")
    func testLinkShortenerViewWithError() {
        let viewModel = makeMockLinkShortenerViewModel(error: "Invalid URL format")
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - Items with Loading")
    func testLinkShortenerViewItemsWithLoading() {
        let items = [
            ShortenedLinkViewObject(
                id: "1",
                originalURL: "https://www.example.com",
                shortURL: "https://short.ly/abc123"
            )
        ]
        let viewModel = makeMockLinkShortenerViewModel(items: items, isLoading: true)
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 390, height: 812))
    }

    @Test("LinkShortenerView - Compact Size (iPhone SE)")
    func testLinkShortenerViewCompactSize() {
        let items = [
            ShortenedLinkViewObject(
                id: "1",
                originalURL: "https://example.com",
                shortURL: "https://short.ly/1"
            )
        ]
        let viewModel = makeMockLinkShortenerViewModel(items: items)
        let view = LinkShortenerView(viewModel: viewModel)
        assertVariantSnapshot(view, layout: .fixed(width: 375, height: 667))
    }
}
