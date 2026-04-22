import XCTest

struct LinkShortenerScreen {
    let app: XCUIApplication

    private var urlTextField: XCUIElement {
        app.textFields["urlTextField"]
    }

    private var shortenButton: XCUIElement {
        app.buttons["shortenButton"]
    }

    private var shortenedItem: XCUIElement {
        app.descendants(matching: .any)["shortenedItem"].firstMatch
    }

    private var loadingIndicator: XCUIElement {
        app.activityIndicators.firstMatch
    }

    private var errorAlert: XCUIElement {
        app.alerts.firstMatch
    }

    @discardableResult
    func verify() -> Self {
        XCTAssertTrue(urlTextField.waitForExistence(timeout: 10), "Link Shortener screen should be visible")
        return self
    }

    @discardableResult
    func enterURL(_ url: String) -> Self {
        urlTextField.clearAndTypeText(url)
        return self
    }

    @discardableResult
    func tapShorten() -> Self {
        shortenButton.tap()
        return self
    }

    @discardableResult
    func assertShortenedURLVisible(_ url: String, timeout: TimeInterval = 10) -> Self {
        let text = app.staticTexts[url]
        XCTAssertTrue(text.waitForExistence(timeout: timeout), "Shortened URL \(url) should be visible")
        return self
    }

    @discardableResult
    func assertShortenButtonEnabled(_ enabled: Bool) -> Self {
        XCTAssertEqual(shortenButton.isEnabled, enabled, "Shorten button enabled state mismatch")
        return self
    }

    @discardableResult
    func assertLoadingIndicatorVisible(_ visible: Bool) -> Self {
        if visible {
            XCTAssertTrue(loadingIndicator.waitForExistence(timeout: 2), "Loading indicator should be visible")
        } else {
            XCTAssertTrue(loadingIndicator.waitForNonExistence(timeout: 5), "Loading indicator should disappear")
        }
        return self
    }

    @discardableResult
    func assertErrorAlertVisible() -> Self {
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 10), "Error alert should be visible")
        return self
    }
}
