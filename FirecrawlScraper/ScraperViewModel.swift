import Foundation
import SwiftUI

@MainActor
class ScraperViewModel: ObservableObject {
    @Published var scrapedContent: ScrapedContent?
    @Published var isLoading = false
    @Published var errorMessage: String?

    #if os(macOS)
    private let mcpService = MCPServiceMac()
    #else
    private let mcpService = MCPService()
    #endif

    func scrapeURL(_ urlString: String) {
        // Ensure URL has a scheme (http:// or https://)
        var processedURLString = urlString.trimmingCharacters(in: .whitespaces)

        if !processedURLString.lowercased().hasPrefix("http://") && !processedURLString.lowercased().hasPrefix("https://") {
            processedURLString = "https://" + processedURLString
        }

        guard let url = URL(string: processedURLString) else {
            errorMessage = "Invalid URL"
            return
        }

        print("Processing URL: \(processedURLString)")

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let content = try await mcpService.scrapeWebsite(url: url)
                self.scrapedContent = content
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error scraping: \(error)")
            }
            isLoading = false
        }
    }
}
