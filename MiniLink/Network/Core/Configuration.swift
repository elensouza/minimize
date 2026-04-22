import Foundation

struct Configuration {
    static let shared = Configuration()

    let baseURL: String

    private init() {
        guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        self.baseURL = baseURL
    }
}
