import Foundation
import SwiftUI

@MainActor
class ScraperViewModel: ObservableObject {
    @Published var scrapedContent: ScrapedContent?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let mcpService = MCPService()

    func scrapeURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

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
