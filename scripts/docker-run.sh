#!/bin/bash

# Simple Docker run script for MCP GitHub Projects Server
set -e

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ .env file not found. Please create one from .env.example"
    exit 1
fi

# Build the image
echo "🏗️  Building Docker image..."
docker build -t mcp-github-projects .

# Run the container
echo "🚀 Starting MCP GitHub Projects Server..."
docker run -d \
  --name mcp-github-projects \
  -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  -e GITHUB_TOKEN="$GITHUB_TOKEN" \
  -e GITHUB_OWNER="$GITHUB_OWNER" \
  -e GITHUB_OWNER_TYPE="$GITHUB_OWNER_TYPE" \
  -e ALLOWED_REPOS="$ALLOWED_REPOS" \
  mcp-github-projects

echo "✅ Container started! Use these commands:"
echo "  docker logs mcp-github-projects     # View logs"
echo "  docker exec -it mcp-github-projects /bin/bash  # Shell access"
echo "  docker stop mcp-github-projects     # Stop"
echo "  docker rm mcp-github-projects       # Remove"
