# FirecrawlScraper macOS Version Setup Guide

## What's Been Prepared

I've created all the necessary files for the macOS version:

1. **FirecrawlScraperMacApp.swift** - macOS app entry point
2. **MCPClient.swift** - MCP client with stdio transport (macOS only)
3. **MCPServiceMac.swift** - Service that uses MCP client
4. **ScraperViewModel.swift** - Updated to use correct service per platform

## Step 1: Add macOS Target in Xcode

1. Open `FirecrawlScraper.xcodeproj` in Xcode:
   ```bash
   open FirecrawlScraper.xcodeproj
   ```

2. In Xcode, click on the **project** (blue icon) in the Project Navigator (left sidebar)

3. In the main editor area, you'll see a list of targets. Click the **"+"** button at the bottom of the targets list

4. In the template chooser:
   - Select **macOS** tab at the top
   - Choose **App** template
   - Click **Next**

5. Configure the new target:
   - **Product Name**: `FirecrawlScraperMac`
   - **Team**: (select your team)
   - **Organization Identifier**: `com.firecrawl` (or your identifier)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - Uncheck "Create Document-Based Application"
   - Click **Finish**

6. When asked "Would you like to add these files to the FirecrawlScraper scheme?", click **Don't Add**

## Step 2: Configure Target Membership

Now you need to tell Xcode which files belong to which target:

### Files for macOS target ONLY:
1. Find `FirecrawlScraperMacApp.swift` in Project Navigator
2. Click on it, then open the **File Inspector** (right sidebar, first tab)
3. In **Target Membership** section, check **FirecrawlScraperMac** ONLY

### Files for iOS target ONLY:
1. Find `FirecrawlScraperApp.swift`
2. Make sure ONLY **FirecrawlScraper** (iOS) is checked
3. Find `MCPService.swift`
4. Make sure ONLY **FirecrawlScraper** (iOS) is checked

### Files for BOTH targets:
For each of these files, check BOTH `FirecrawlScraper` AND `FirecrawlScraperMac`:
- `ContentView.swift`
- `Models.swift`
- `ScraperViewModel.swift`
- `Config.swift`
- `TappableTextView.swift`
- `GameLinks.swift`
- `MCPClient.swift`
- `MCPServiceMac.swift`

**Quick way**: Select multiple files at once (hold Command), then check both targets in File Inspector.

### Remove auto-generated files (if any):
- If Xcode created `ContentView.swift` inside a `FirecrawlScraperMac` folder, delete it
- We're using the shared `ContentView.swift` instead

## Step 3: Install firecrawl-mcp-server

The macOS version needs the firecrawl-mcp-server to be installed on your system.

### Option A: Install globally with npm
```bash
npm install -g @mendable/firecrawl-mcp-server
```

### Option B: Install with npx (no installation needed)
The app can use `npx @mendable/firecrawl-mcp-server` instead

To use npx, modify `MCPServiceMac.swift` line 35:
```swift
// Change from:
self.mcpClient = MCPClient(transport: "stdio", command: ["firecrawl-mcp-server"])

// To:
self.mcpClient = MCPClient(transport: "stdio", command: ["npx", "@mendable/firecrawl-mcp-server"])
```

## Step 4: Build and Run

1. In Xcode, select the **FirecrawlScraperMac** scheme (dropdown next to the play button)
2. Select **My Mac** as the destination
3. Click the **Run** button (▶️) or press `⌘R`

The macOS app will launch and use MCP with stdio transport!

## Differences Between iOS and macOS Versions

### iOS Version (FirecrawlScraper)
- ✅ Uses direct HTTP REST API
- ✅ Works on iPhone and iPad
- ❌ Cannot use stdio transport (iOS sandboxing limitation)

### macOS Version (FirecrawlScraperMac)
- ✅ Uses MCP protocol with stdio transport
- ✅ Can spawn subprocess (firecrawl-mcp-server)
- ✅ More flexible integration
- ✅ Works on macOS 11.0+

## Troubleshooting

### Build Error: "Cannot find 'MCPServiceMac'"
- Make sure `MCPServiceMac.swift` has target membership for `FirecrawlScraperMac`
- Clean build folder: Product → Clean Build Folder (⇧⌘K)

### Build Error: "Cannot find 'ContentView'"
- Make sure `ContentView.swift` has target membership for BOTH targets

### Runtime Error: "MCP server process failed to start"
- Make sure `firecrawl-mcp-server` is installed and in your PATH
- Try running `which firecrawl-mcp-server` in Terminal
- Or modify the code to use `npx` (see Step 3, Option B)

### Runtime Error: "Command not found: firecrawl-mcp-server"
- Install Node.js from https://nodejs.org
- Install the server: `npm install -g @mendable/firecrawl-mcp-server`
- Restart Xcode after installation

## Verifying MCP Setup

Run this script to check if everything is installed:
```bash
./check-mcp-setup.sh
```

## What Happens Under the Hood

1. macOS app starts and initializes `MCPServiceMac`
2. `MCPServiceMac` creates an `MCPClient` with stdio transport
3. When you scrape a URL, the client:
   - Spawns `firecrawl-mcp-server` as a subprocess
   - Communicates via stdin/stdout using JSON-RPC 2.0 protocol
   - Sends tool call requests to scrape URLs
   - Receives structured responses
4. Results are displayed in the SwiftUI interface

This architecture allows for more flexible and extensible integrations using the Model Context Protocol!
