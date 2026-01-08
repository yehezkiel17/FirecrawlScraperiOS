import Foundation

#if os(macOS)

class MCPServiceMac {
    private let mcpClient: MCPClient
    private let config = FirecrawlConfig.shared
    private var isClientStarted = false

    enum FirecrawlError: LocalizedError {
        case noAPIKey
        case invalidResponse
        case apiError(String)
        case clientNotStarted
        case mcpError(String)

        var errorDescription: String? {
            switch self {
            case .noAPIKey:
                return "Firecrawl API key not configured. Please add your API key in settings."
            case .invalidResponse:
                return "Invalid response from Firecrawl API"
            case .apiError(let message):
                return "Firecrawl API Error: \(message)"
            case .clientNotStarted:
                return "MCP client not started. Please start the client first."
            case .mcpError(let message):
                return "MCP Error: \(message)"
            }
        }
    }

    init() {
        // Initialize MCPClient with stdio transport and firecrawl-mcp-server command
        // Option 1: If installed globally
        // self.mcpClient = MCPClient(transport: "stdio", command: ["firecrawl-mcp-server"])

        // Option 2: Using wrapper script that sets up PATH for Node.js
        // This is needed because macOS GUI apps don't inherit shell PATH
        // Using absolute path to the script in the source directory
        self.mcpClient = MCPClient(transport: "stdio", command: ["/Users/litbagayy/AI/FirecrawlScraper/run-mcp-server.sh"])
    }

    // Start the MCP client and initialize the connection
    func startClient() async throws {
        guard !isClientStarted else { return }

        do {
            try mcpClient.start()
            try await mcpClient.initialize(clientInfo: [
                "name": "FirecrawlScraper",
                "version": "1.0.0"
            ])
            isClientStarted = true
        } catch {
            throw FirecrawlError.mcpError(error.localizedDescription)
        }
    }

    // Stop the MCP client
    func stopClient() {
        mcpClient.stop()
        isClientStarted = false
    }

    func scrapeWebsite(url: URL) async throws -> ScrapedContent {
        // Ensure client is started
        if !isClientStarted {
            try await startClient()
        }

        // Check if API key is configured (still needed for the firecrawl-mcp-server)
        guard config.hasValidAPIKey else {
            throw FirecrawlError.noAPIKey
        }

        do {
            // Call the firecrawl_scrape tool via MCP
            print("Scraping URL: \(url.absoluteString)")

            let arguments: [String: Any] = [
                "url": url.absoluteString,
                "formats": ["markdown"],
                "onlyMainContent": true
            ]

            print("Tool arguments: \(arguments)")

            let result = try await mcpClient.callTool(
                name: "firecrawl_scrape",
                arguments: arguments
            )

            // Debug: Print the full response structure
            print("MCP Response: \(result)")

            // Parse the MCP response
            // The firecrawl_scrape tool returns: { "content": [{ "text": "...", "type": "text" }] }
            // The text field contains a JSON string with markdown and metadata

            guard let content = result["content"] as? [[String: Any]],
                  let firstContent = content.first,
                  let textContent = firstContent["text"] as? String,
                  let textData = textContent.data(using: .utf8),
                  let parsedData = try? JSONSerialization.jsonObject(with: textData) as? [String: Any] else {
                print("Failed to parse MCP response: \(result)")
                throw FirecrawlError.invalidResponse
            }

            // Extract markdown content and metadata
            let markdown = parsedData["markdown"] as? String
            let metadata = parsedData["metadata"] as? [String: Any]
            let title = metadata?["title"] as? String
            let description = metadata?["description"] as? String

            guard let content = markdown, !content.isEmpty else {
                print("No markdown content in response")
                throw FirecrawlError.invalidResponse
            }

            print("Successfully extracted markdown: \(content.prefix(100))...")

            var extractedMetadata: [String: String] = [
                "scraped_at": ISO8601DateFormatter().string(from: Date()),
                "source": "Firecrawl MCP Server"
            ]

            // Add metadata from Firecrawl response
            if let metadata = metadata {
                for (key, value) in metadata {
                    if let stringValue = value as? String {
                        extractedMetadata[key] = stringValue
                    } else if let numberValue = value as? NSNumber {
                        extractedMetadata[key] = numberValue.stringValue
                    }
                }
            }

            return ScrapedContent(
                title: title,
                description: description,
                content: content,
                url: url.absoluteString,
                metadata: extractedMetadata
            )
        } catch let error as MCPClient.MCPError {
            throw FirecrawlError.mcpError(error.localizedDescription)
        } catch {
            throw FirecrawlError.apiError(error.localizedDescription)
        }
    }

    // List available tools from the MCP server
    func listAvailableTools() async throws -> [[String: Any]] {
        if !isClientStarted {
            try await startClient()
        }

        do {
            return try await mcpClient.listTools()
        } catch {
            throw FirecrawlError.mcpError(error.localizedDescription)
        }
    }
}

#endif
