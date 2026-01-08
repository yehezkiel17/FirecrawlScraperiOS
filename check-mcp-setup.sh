#!/bin/bash

echo "🔍 Checking MCP Setup for macOS..."
echo ""

# Check if firecrawl-mcp-server is available
if command -v firecrawl-mcp-server &> /dev/null; then
    echo "✅ firecrawl-mcp-server is installed"
    echo "   Location: $(which firecrawl-mcp-server)"
else
    echo "❌ firecrawl-mcp-server is NOT installed"
    echo ""
    echo "To install firecrawl-mcp-server:"
    echo "  1. Install Node.js if you haven't: https://nodejs.org"
    echo "  2. Install the MCP server:"
    echo "     npm install -g @mendable/firecrawl-mcp-server"
    echo "     or"
    echo "     npx @mendable/firecrawl-mcp-server"
fi

echo ""
echo "📁 Files created for macOS version:"
ls -l FirecrawlScraper/FirecrawlScraperMacApp.swift 2>/dev/null && echo "  ✅ FirecrawlScraperMacApp.swift"
ls -l FirecrawlScraper/MCPClient.swift 2>/dev/null && echo "  ✅ MCPClient.swift"
ls -l FirecrawlScraper/MCPServiceMac.swift 2>/dev/null && echo "  ✅ MCPServiceMac.swift"

echo ""
echo "📖 Next steps:"
echo "  1. Open FirecrawlScraper.xcodeproj in Xcode"
echo "  2. Follow instructions in add-macos-target.md"
echo "  3. Build and run the macOS target"
