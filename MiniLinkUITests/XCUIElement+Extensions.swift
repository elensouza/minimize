import XCTest

extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        guard waitForExistence(timeout: 5) else {
            XCTFail("Element not found for typing")
            return
        }

        tap()
        
        let hasFocus = NSPredicate(format: "hasKeyboardFocus == true")
        let expectation = XCTNSPredicateExpectation(predicate: hasFocus, object: self)
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        
        if result != .completed {
            tap()
        }

        if let currentValue = value as? String, !currentValue.isEmpty {
            doubleTap()
            typeText(XCUIKeyboardKey.delete.rawValue)
        }

        typeText(text)
    }

    @discardableResult
    func waitForNonExistence(timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
