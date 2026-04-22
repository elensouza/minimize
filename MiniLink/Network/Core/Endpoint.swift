import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Encodable? { get }
}

extension Endpoint {
    var url: URL {
        guard let url = URL(string: baseURL + path) else {
            fatalError("Invalid URL constructed from baseURL: \(baseURL) and path: \(path)")
        }
        return url
    }

    var headers: [String: String] { [:] }
    var body: Encodable? { nil }
}
