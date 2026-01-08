# Adding macOS Target to FirecrawlScraper

## Option 1: Using Xcode GUI (Recommended)

1. Open `FirecrawlScraper.xcodeproj` in Xcode
2. Select the project in the navigator (top item)
3. Click the "+" button at the bottom of the targets list
4. Select "macOS" → "App" → Click "Next"
5. Name it "FirecrawlScraperMac"
6. Set:
   - Product Name: FirecrawlScraperMac
   - Organization Identifier: com.firecrawl
   - Interface: SwiftUI
   - Language: Swift
7. Click "Finish"

## Option 2: Files Are Already Created

I've created the necessary files:
- `FirecrawlScraperMacApp.swift` - macOS app entry point
- `MCPClient.swift` - MCP client (macOS only, wrapped in `#if os(macOS)`)
- `MCPServiceMac.swift` - macOS MCP service

## After Creating the Target:

1. **Remove the auto-generated ContentView.swift** from the macOS target (if created)

2. **Add shared files to macOS target**:
   - Right-click each shared file in Project Navigator
   - Check "Target Membership" for FirecrawlScraperMac
   - Add these files:
     - ContentView.swift
     - Models.swift
     - ScraperViewModel.swift
     - Config.swift
     - TappableTextView.swift
     - GameLinks.swift
     - MCPClient.swift
     - MCPServiceMac.swift

3. **Update ScraperViewModel.swift** to use the correct service:
   ```swift
   #if os(macOS)
   private let mcpService = MCPServiceMac()
   #else
   private let mcpService = MCPService()
   #endif
   ```

4. **Don't add these iOS-only files**:
   - FirecrawlScraperApp.swift (iOS entry point)
   - MCPService.swift (iOS HTTP service)

5. **Add FirecrawlScraperMacApp.swift** to macOS target only

## Build and Run

1. Select "FirecrawlScraperMac" scheme in Xcode
2. Select "My Mac" as the destination
3. Click Run (⌘R)

The macOS version will use MCP with stdio transport to communicate with firecrawl-mcp-server!
