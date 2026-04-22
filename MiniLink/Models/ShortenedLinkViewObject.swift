struct ShortenedLinkViewObject: Identifiable, Equatable, Sendable {
    let id: String
    let originalURL: String
    let shortURL: String
}
