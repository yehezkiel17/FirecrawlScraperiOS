import Foundation

class MCPService {
    private let firecrawlAPIURL = "https://api.firecrawl.dev/v1/scrape"
    private let config = FirecrawlConfig.shared

    enum FirecrawlError: LocalizedError {
        case noAPIKey
        case invalidResponse
        case apiError(String)

        var errorDescription: String? {
            switch self {
            case .noAPIKey:
                return "Firecrawl API key not configured. Please add your API key in settings."
            case .invalidResponse:
                return "Invalid response from Firecrawl API"
            case .apiError(let message):
                return "Firecrawl API Error: \(message)"
            }
        }
    }

    func scrapeWebsite(url: URL) async throws -> ScrapedContent {
        // Check if API key is configured
        guard config.hasValidAPIKey else {
            throw FirecrawlError.noAPIKey
        }

        // Create the request
        let requestBody = FirecrawlScrapeRequest(
            url: url.absoluteString,
            formats: ["markdown", "html"],
            onlyMainContent: true,
            includeTags: nil,
            excludeTags: nil
        )

        // Prepare URL request
        guard let apiURL = URL(string: firecrawlAPIURL) else {
            throw FirecrawlError.invalidResponse
        }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")

        // Encode request body
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)

        // Make the API call
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FirecrawlError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw FirecrawlError.apiError("Status \(httpResponse.statusCode): \(errorMessage)")
        }

        // Decode response
        let decoder = JSONDecoder()
        let firecrawlResponse = try decoder.decode(FirecrawlScrapeResponse.self, from: data)

        // Check if request was successful
        guard firecrawlResponse.success, let data = firecrawlResponse.data else {
            throw FirecrawlError.apiError(firecrawlResponse.error ?? "Unknown error")
        }

        // Convert to ScrapedContent
        return ScrapedContent(
            title: data.metadata?.title ?? data.metadata?.ogTitle,
            description: data.metadata?.description ?? data.metadata?.ogDescription,
            content: data.markdown ?? data.content ?? data.html ?? "No content extracted",
            url: url.absoluteString,
            metadata: [
                "scraped_at": ISO8601DateFormatter().string(from: Date()),
                "source": "Firecrawl API",
                "language": data.metadata?.language ?? "unknown"
            ]
        )
    }
}
