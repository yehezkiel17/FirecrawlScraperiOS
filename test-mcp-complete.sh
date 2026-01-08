#!/bin/bash

echo "Testing complete MCP flow..."
echo ""

# Start the MCP server and send requests
{
    sleep 0.5
    echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
    sleep 0.5
    echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"firecrawl_scrape","arguments":{"url":"https://example.com","formats":["markdown"],"onlyMainContent":true}}}'
    sleep 30  # Wait for scraping to complete
} | /Users/litbagayy/AI/FirecrawlScraper/run-mcp-server.sh 2>&1 | while IFS= read -r line; do
    echo "$line"
    # Check if this is the final scrape result
    if echo "$line" | grep -q '"id":2'; then
        echo ""
        echo "✅ Got response for scrape request!"
        break
    fi
done
