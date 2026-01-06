#!/bin/bash

# Semicolon Server Startup Script (Linux/Mac)
# This script runs both backend and frontend servers

set -e

echo "=========================================="
echo "Semicolon Server Startup Script"
echo "=========================================="

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set current directory as project root
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

echo -e "${BLUE}Project root: ${PROJECT_ROOT}${NC}"
echo ""

# Check and create Python virtual environment
echo -e "${BLUE}[1/5] Setting up Python environment...${NC}"
cd "${PROJECT_ROOT}/backend"

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install Python packages
echo "Installing Python dependencies..."
pip install -q -e .

echo -e "${GREEN}✓ Python environment ready${NC}"
echo ""

# Install Node.js packages
echo -e "${BLUE}[2/5] Setting up Node.js environment...${NC}"
cd "${PROJECT_ROOT}/frontend"

if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
else
    echo "Node.js dependencies already installed."
fi

echo -e "${GREEN}✓ Node.js environment ready${NC}"
echo ""

# Build frontend
echo -e "${BLUE}[3/5] Building frontend...${NC}"
npm run build
echo -e "${GREEN}✓ Frontend build complete${NC}"
echo ""

# Start backend
echo -e "${BLUE}[4/5] Starting backend server...${NC}"
cd "${PROJECT_ROOT}/backend"

# Run backend in background
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload > backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend server started with PID ${BACKEND_PID}"
echo -e "${GREEN}✓ Backend server: http://localhost:8000${NC}"
echo ""

# Start frontend
echo -e "${BLUE}[5/5] Starting frontend server...${NC}"
cd "${PROJECT_ROOT}/frontend"

# Start frontend preview server
nohup npm run preview -- --host 0.0.0.0 --port 3000 > frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend server started with PID ${FRONTEND_PID}"
echo -e "${GREEN}✓ Frontend server: http://localhost:3000${NC}"
echo ""

# Save PID files
echo $BACKEND_PID > "${PROJECT_ROOT}/backend.pid"
echo $FRONTEND_PID > "${PROJECT_ROOT}/frontend.pid"

echo "=========================================="
echo -e "${GREEN}Servers started successfully!${NC}"
echo "=========================================="
echo ""
echo "Service URLs:"
echo "  - Frontend: http://localhost:3000"
echo "  - Backend API: http://localhost:8000"
echo "  - API Docs: http://localhost:8000/docs"
echo ""
echo "Log files:"
echo "  - Backend: ${PROJECT_ROOT}/backend/backend.log"
echo "  - Frontend: ${PROJECT_ROOT}/frontend/frontend.log"
echo ""
echo "To stop servers: ./stop.sh"
echo ""
