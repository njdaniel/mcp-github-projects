# Simple Bun-based Dockerfile for MCP GitHub Projects Server
FROM oven/bun:1-alpine

# Install necessary packages: curl and bash
RUN apk add --no-cache curl bash git

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json bun.lock ./

# Install dependencies
RUN bun install

# Copy source code
COPY . .

# Command to start the MCP server
CMD ["bun", "run", "src/index.ts"]
