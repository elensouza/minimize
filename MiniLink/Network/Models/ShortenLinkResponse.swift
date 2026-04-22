struct ShortenLinkResponse: Decodable, Sendable {
    let alias: String
    let links: Links

    enum CodingKeys: String, CodingKey {
        case alias
        case links = "_links"
    }

    struct Links: Decodable, Sendable {
        let original: String
        let short: String

        enum CodingKeys: String, CodingKey {
            case original = "self"
            case short
        }
    }
}
