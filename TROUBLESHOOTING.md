# Troubleshooting FirecrawlScraperMac

## Error: "Invalid response from MCP server" or "Failed to read any data"

### Root Cause
The `firecrawl-mcp-server` command is not found on your system.

### Solutions

#### ✅ Solution 1: Use npx (Already configured - default)
The app is now configured to use `npx` which automatically downloads and runs the package.

**No installation needed!** Just run the app and it will work.

**First run will be slower** as npx downloads the package.

#### ✅ Solution 2: Install globally (Faster startup)
```bash
npm install -g @mendable/firecrawl-mcp-server
```

Then update `MCPServiceMac.swift` line 39:
```swift
// Change from:
self.mcpClient = MCPClient(transport: "stdio", command: ["npx", "-y", "@mendable/firecrawl-mcp-server"])

// To:
self.mcpClient = MCPClient(transport: "stdio", command: ["firecrawl-mcp-server"])
```

### Verify Installation

Run the test script:
```bash
./test-mcp-server.sh
```

Or manually:
```bash
which firecrawl-mcp-server
# Should show path if installed

# Or test with npx:
npx @mendable/firecrawl-mcp-server --version
```

## How to View Debug Logs

1. **Open in Xcode:**
   ```bash
   open FirecrawlScraper.xcodeproj
   ```

2. **Select macOS scheme:**
   - Click on "FirecrawlScraper" next to the play button
   - Select "FirecrawlScraperMac"

3. **Run the app:**
   - Press ⌘R or click the Play button

4. **Open Debug Console:**
   - Press ⇧⌘Y
   - Or: View → Debug Area → Activate Console

5. **Try scraping a URL** - you'll see detailed logs like:
   ```
   Starting process: /usr/bin/env npx -y @mendable/firecrawl-mcp-server
   Process started successfully, PID: 12345
   Sending request: { ... }
   Received response: { ... }
   ```

## Common Issues

### Issue: "Command not found"
**Fix:** The app now uses `npx` which handles this automatically.

### Issue: Process starts but no response
**Check:**
1. Is your Firecrawl API key set in `Config.swift`?
2. Check the Console logs for stderr messages
3. Try a different URL

### Issue: NPM/npx not found
**Fix:** Install Node.js from https://nodejs.org

### Issue: Slow first startup
**Reason:** npx is downloading the package for the first time.
**Fix:** Wait for the download to complete, or install globally (Solution 2 above).

## Testing MCP Server Manually

Test the server directly from terminal:
```bash
# Using npx
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{}}}' | npx @mendable/firecrawl-mcp-server

# Or if installed globally
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{}}}' | firecrawl-mcp-server
```

You should see a JSON response with server capabilities.

## Debug Mode Changes

The app now includes extensive logging:
- ✅ Process startup verification
- ✅ Command existence checking
- ✅ Request/response logging
- ✅ stderr capture
- ✅ Multiple response format parsing

All logs appear in Xcode's Debug Console.
