#!/bin/bash

echo "🔍 Testing Firecrawl MCP Server..."
echo ""

# Check if firecrawl-mcp-server is installed
if command -v firecrawl-mcp-server &> /dev/null; then
    echo "✅ firecrawl-mcp-server is installed"
    echo "   Location: $(which firecrawl-mcp-server)"
    echo ""

    # Test if it can start
    echo "🧪 Testing if server can start..."
    echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{}}}' | timeout 5 firecrawl-mcp-server 2>&1 | head -5

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Server responded successfully!"
    else
        echo ""
        echo "⚠️  Server started but may have issues"
    fi
else
    echo "❌ firecrawl-mcp-server is NOT installed"
    echo ""
    echo "To install:"
    echo "  npm install -g @mendable/firecrawl-mcp-server"
    echo ""
    echo "Or check if it's available via npx:"
    if npx -y @mendable/firecrawl-mcp-server --version &> /dev/null; then
        echo "  ✅ Available via npx"
        echo "  Update MCPServiceMac.swift to use:"
        echo '     command: ["npx", "@mendable/firecrawl-mcp-server"]'
    else
        echo "  ❌ Not available via npx either"
    fi
fi

echo ""
echo "📝 To see detailed logs when running the macOS app:"
echo "   1. Run from Xcode (not by double-clicking)"
echo "   2. Open Console: View → Debug Area → Show Debug Area (⇧⌘Y)"
echo "   3. Try scraping a URL"
