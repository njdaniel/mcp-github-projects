#!/bin/bash

# Docker Development Scripts for MCP GitHub Projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 {start|stop|build|clean|logs|shell|test}"
    echo ""
    echo "Commands:"
    echo "  start  - Start MCP server"
    echo "  stop   - Stop MCP server"
    echo "  build  - Build Docker image"
    echo "  clean  - Clean up containers and images"
    echo "  logs   - Show container logs"
    echo "  shell  - Open shell in container"
    echo "  test   - Run tests in container"
    echo ""
}

check_env() {
    if [ ! -f .env ]; then
        echo -e "${YELLOW}Warning: .env file not found. Copying from .env.example${NC}"
        cp .env.example .env
        echo -e "${RED}Please edit .env file with your GitHub token before continuing${NC}"
        exit 1
    fi
}

case "$1" in
    start)
        echo -e "${GREEN}Starting MCP GitHub Projects server...${NC}"
        check_env
        docker compose up -d mcp-github
        echo -e "${GREEN}MCP server started. Access at http://localhost:3000${NC}"
        ;;
    stop)
        echo -e "${YELLOW}Stopping MCP server...${NC}"
        docker compose down
        echo -e "${GREEN}MCP server stopped${NC}"
        ;;
    build)
        echo -e "${GREEN}Building Docker image...${NC}"
        docker compose build
        echo -e "${GREEN}Build completed${NC}"
        ;;
    clean)
        echo -e "${YELLOW}Cleaning up containers and images...${NC}"
        docker compose down -v
        docker system prune -f
        echo -e "${GREEN}Cleanup completed${NC}"
        ;;
    logs)
        docker compose logs -f mcp-github
        ;;
    shell)
        echo -e "${GREEN}Opening shell in container...${NC}"
        docker compose exec mcp-github /bin/bash
        ;;
    test)
        echo -e "${GREEN}Running tests in container...${NC}"
        docker compose exec mcp-github bun test
        ;;
    *)
        print_usage
        exit 1
        ;;
esac
