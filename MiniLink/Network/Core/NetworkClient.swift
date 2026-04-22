import Foundation

protocol NetworkClient: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
