import XCTest

final class LinkShortenerUITests: XCTestCase {
    private var app: XCUIApplication!
    private var screen: LinkShortenerScreen!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        launchApp()
    }

    override func tearDown() {
        screen = nil
        app = nil
        super.tearDown()
    }

    func testShortenURLFlow() {
        screen
            .verify()
            .enterURL("https://google.com")
            .assertShortenButtonEnabled(true)
            .tapShorten()
            .assertShortenedURLVisible("https://short.ly/uitest123")
    }

    func testButtonDisabledWhenInputIsEmpty() {
        screen
            .verify()
            .assertShortenButtonEnabled(false)
    }

    func testTypingEnablesButton() {
        screen
            .verify()
            .enterURL("https://apple.com")
            .assertShortenButtonEnabled(true)
    }

    func testLoadingState() {
        launchApp(environment: ["REPOSITORY_DELAY": "3"])

        screen
            .verify()
            .enterURL("https://google.com\n")
            .tapShorten()
            .assertLoadingIndicatorVisible(true)
            .assertShortenedURLVisible("https://short.ly/uitest123", timeout: 15)
            .assertLoadingIndicatorVisible(false)
            .assertShortenButtonEnabled(false)
    }

    func testErrorScenario() {
        launchApp(environment: ["TEST_SCENARIO": "ERROR", "REPOSITORY_DELAY": "1"])

        screen
            .verify()
            .enterURL("https://google.com\n")
            .tapShorten()
            .assertErrorAlertVisible()
    }

    private func launchApp(environment: [String: String] = [:]) {
        app?.terminate()

        app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launchEnvironment = environment
        app.launch()
        
        screen = LinkShortenerScreen(app: app)
    }
}
