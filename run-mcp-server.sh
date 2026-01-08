#!/bin/bash
# Wrapper script to run Firecrawl MCP Server with correct PATH for macOS GUI apps

# Set up the PATH to include Node.js binaries
export PATH="/Users/litbagayy/.nvm/versions/node/v24.12.0/bin:$PATH"

# Set the Firecrawl API key
export FIRECRAWL_API_KEY="YOUR_FIRECRAWL_API_KEY"

# Run npx with the firecrawl MCP server
exec npx -y firecrawl-mcp
