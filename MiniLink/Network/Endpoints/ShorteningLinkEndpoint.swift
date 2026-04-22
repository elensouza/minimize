import Foundation

enum ShorteningLinkEndpoint {
    case short(payload: ShortenLinkPayload)
}

extension ShorteningLinkEndpoint: Endpoint {
    var baseURL: String {
        Configuration.shared.baseURL
    }

    var path: String {
        switch self {
        case .short:
            "/alias"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .short:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .short(let payload):
            payload
        }
    }
}
