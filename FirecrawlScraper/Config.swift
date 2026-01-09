import Foundation

class FirecrawlConfig {
    static let shared = FirecrawlConfig()

    // MARK: - ⚠️ PASTE YOUR FIRECRAWL API KEY HERE ⚠️
    // Get your API key from: https://firecrawl.dev
    let apiKey = "" // TODO: Add your Firecrawl API key here
    // Example: let apiKey = "fc-1234567890abcdef..."

    private init() {}

    var hasValidAPIKey: Bool {
        !apiKey.isEmpty
    }
}
