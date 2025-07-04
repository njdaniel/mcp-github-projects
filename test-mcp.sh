#!/bin/bash

# Test script for MCP GitHub Projects Server
set -e

echo "🧪 Testing MCP GitHub Projects Server..."
echo "======================================="

# Test 1: Container Health
echo ""
echo "📦 Test 1: Container Health Check"
echo "Status of containers:"
docker compose ps

# Test 2: Process Check
echo ""
echo "🔍 Test 2: Process Check"
echo "Checking if MCP server process is running..."
docker compose exec mcp-github ps aux | grep -E "(bun|node)" || echo "No process found"

# Test 3: Basic MCP Initialization
echo ""
echo "🤝 Test 3: MCP Initialization Test"
echo "Testing MCP server initialization..."

# Create a test JSON-RPC message
cat > /tmp/mcp_init_test.json << 'EOF'
{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "test-client", "version": "1.0.0"}}}
EOF

echo "Sending initialization request..."
timeout 10s docker compose exec -T mcp-github sh -c 'cat | bun run src/index.ts' < /tmp/mcp_init_test.json | head -5

# Test 4: Environment Variables
echo ""
echo "🔐 Test 4: Environment Variables"
echo "Checking if GITHUB_TOKEN is set..."
docker compose exec mcp-github printenv | grep GITHUB || echo "GITHUB_TOKEN not found in environment"

# Test 5: Tool Discovery
echo ""
echo "🛠️  Test 5: Tool Discovery"
echo "Testing tools/resources discovery..."

cat > /tmp/mcp_tools_test.json << 'EOF'
{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}
EOF

echo "Requesting available tools..."
timeout 10s docker compose exec -T mcp-github sh -c 'echo '\''{"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {"protocolVersion": "2024-11-05", "capabilities": {}}}'\'' | bun run src/index.ts & sleep 2; echo '\''{"jsonrpc": "2.0", "id": 2, "method": "tools/list"}'\'' | bun run src/index.ts' | grep -E "(tools|error)" || echo "Tools test completed"

# Cleanup
rm -f /tmp/mcp_init_test.json /tmp/mcp_tools_test.json

echo ""
echo "✅ MCP Server Test Complete!"
echo "If you see initialization responses above, your MCP server is working!"
echo ""
echo "💡 Next steps:"
echo "  - Add this server to Claude Desktop or VS Code"
echo "  - Test with a proper MCP client"
echo "  - Check logs with: make logs"
