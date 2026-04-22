import Foundation
import os

final class DefaultNetworkClient: NetworkClient, Sendable {
    private let logger = Logger(subsystem: "com.MiniLink", category: "network")

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url, timeoutInterval: 15)
        request.httpMethod = endpoint.method.rawValue

        endpoint.headers.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }

        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        logger.info("➡️ Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

        if let headers = request.allHTTPHeaderFields {
            logger.debug("Headers: \(headers)")
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            logger.info("⬅️ Response: \(httpResponse.statusCode) \(request.url?.absoluteString ?? "")")
        }

        if let responseString = String(data: data, encoding: .utf8) {
            logger.debug("Response Body: \(responseString)")
        }

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {

            logger.error("❌ Request failed for \(request.url?.absoluteString ?? "")")
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
