import Foundation

struct ScrapedContent: Codable {
    let title: String?
    let description: String?
    let content: String
    let url: String?
    let metadata: [String: String]?
}

// Firecrawl API Models
struct FirecrawlScrapeRequest: Codable {
    let url: String
    let formats: [String]
    let onlyMainContent: Bool?
    let includeTags: [String]?
    let excludeTags: [String]?

    enum CodingKeys: String, CodingKey {
        case url
        case formats
        case onlyMainContent
        case includeTags
        case excludeTags
    }
}

struct FirecrawlScrapeResponse: Codable {
    let success: Bool
    let data: FirecrawlData?
    let error: String?
}

struct FirecrawlData: Codable {
    let markdown: String?
    let html: String?
    let metadata: FirecrawlMetadata?
    let content: String?
}

struct FirecrawlMetadata: Codable {
    let title: String?
    let description: String?
    let language: String?
    let keywords: String?
    let robots: String?
    let ogTitle: String?
    let ogDescription: String?
    let ogUrl: String?
    let ogImage: String?
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case language
        case keywords
        case robots
        case ogTitle
        case ogDescription
        case ogUrl
        case ogImage
        case sourceURL
    }
}
