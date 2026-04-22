@testable import MiniLink

enum TestError: Error {
    case stubTypeMismatch
}

final class MockLinkShorteningRepository: LinkShorteningRepositoryProtocol, @unchecked Sendable {
    var stubbedResult: ShortenedLinkViewObject?
    var stubbedError: Error?

    func shorten(url: String) async throws -> ShortenedLinkViewObject {
        try await Task.sleep(nanoseconds: 1_000_000)
        if let error = stubbedError { throw error }
        guard let result = stubbedResult else { throw TestError.stubTypeMismatch }
        return result
    }
}

final class MockNetworkClient: NetworkClient, @unchecked Sendable {
    var stubbedResponse: Any?
    var stubbedError: Error?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let error = stubbedError { throw error }
        guard let response = stubbedResponse as? T else { throw TestError.stubTypeMismatch }
        return response
    }
}
