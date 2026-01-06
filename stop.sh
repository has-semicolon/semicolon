#!/bin/bash

# Semicolon Server Stop Script (Linux/Mac)

set -e

echo "=========================================="
echo "Semicolon Server Stop Script"
echo "=========================================="

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set current directory as project root
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

# Check PID files and stop processes
if [ -f "${PROJECT_ROOT}/backend.pid" ]; then
    BACKEND_PID=$(cat "${PROJECT_ROOT}/backend.pid")
    echo -e "${BLUE}Stopping backend server (PID: ${BACKEND_PID})...${NC}"
    
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ Backend server stopped${NC}"
    else
        echo -e "${RED}Backend process already terminated${NC}"
    fi
    
    rm -f "${PROJECT_ROOT}/backend.pid"
else
    echo -e "${RED}Backend PID file not found${NC}"
fi

echo ""

if [ -f "${PROJECT_ROOT}/frontend.pid" ]; then
    FRONTEND_PID=$(cat "${PROJECT_ROOT}/frontend.pid")
    echo -e "${BLUE}Stopping frontend server (PID: ${FRONTEND_PID})...${NC}"
    
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ Frontend server stopped${NC}"
    else
        echo -e "${RED}Frontend process already terminated${NC}"
    fi
    
    rm -f "${PROJECT_ROOT}/frontend.pid"
else
    echo -e "${RED}Frontend PID file not found${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Servers stopped${NC}"
echo "=========================================="
