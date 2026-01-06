#!/bin/bash

# Semicolon Development Mode Script (Linux/Mac)
# This script runs both backend and frontend in development mode

set -e

echo "=========================================="
echo "Semicolon Development Mode"
echo "=========================================="

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set current directory as project root
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

echo -e "${BLUE}Project root: ${PROJECT_ROOT}${NC}"
echo ""

# Check Python virtual environment
echo -e "${BLUE}[1/3] Checking Python environment...${NC}"
cd "${PROJECT_ROOT}/backend"

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -q -e .
else
    source venv/bin/activate
fi

echo -e "${GREEN}✓ Python environment ready${NC}"
echo ""

# Check Node.js packages
echo -e "${BLUE}[2/3] Checking Node.js environment...${NC}"
cd "${PROJECT_ROOT}/frontend"

if [ ! -d "node_modules" ]; then
    echo "Installing Node.js dependencies..."
    npm install
fi

echo -e "${GREEN}✓ Node.js environment ready${NC}"
echo ""

# Start servers
echo -e "${BLUE}[3/3] Starting development servers...${NC}"
echo ""

# Check if tmux or screen is available
if command -v tmux &> /dev/null; then
    echo "Starting servers using tmux..."
    echo "To attach to session: tmux attach -t semicolon"
    
    # Kill existing session if it exists
    tmux kill-session -t semicolon 2>/dev/null || true
    
    # Start new session
    tmux new-session -d -s semicolon
    
    # Backend window
    tmux send-keys -t semicolon "cd ${PROJECT_ROOT}/backend && source venv/bin/activate && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload" C-m
    
    # Create frontend window
    tmux split-window -h -t semicolon
    tmux send-keys -t semicolon "cd ${PROJECT_ROOT}/frontend && npm run dev -- --host 0.0.0.0 --port 3000" C-m
    
    echo ""
    echo -e "${GREEN}Development servers started!${NC}"
    echo ""
    echo "Service URLs:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend API: http://localhost:8000"
    echo "  - API Docs: http://localhost:8000/docs"
    echo ""
    echo "Attach to tmux session: tmux attach -t semicolon"
    echo "Detach from tmux: Ctrl+B, D"
    echo "Kill session: tmux kill-session -t semicolon"
    
else
    echo "Starting backend and frontend in background..."
    
    # Start backend
    cd "${PROJECT_ROOT}/backend"
    nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload > backend-dev.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > "${PROJECT_ROOT}/backend-dev.pid"
    
    # Start frontend
    cd "${PROJECT_ROOT}/frontend"
    nohup npm run dev -- --host 0.0.0.0 --port 3000 > frontend-dev.log 2>&1 &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > "${PROJECT_ROOT}/frontend-dev.pid"
    
    echo ""
    echo -e "${GREEN}Development servers started!${NC}"
    echo ""
    echo "Service URLs:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend API: http://localhost:8000"
    echo "  - API Docs: http://localhost:8000/docs"
    echo ""
    echo "Log files:"
    echo "  - Backend: ${PROJECT_ROOT}/backend/backend-dev.log"
    echo "  - Frontend: ${PROJECT_ROOT}/frontend/frontend-dev.log"
    echo ""
    echo "View logs: tail -f backend/backend-dev.log"
    echo "           tail -f frontend/frontend-dev.log"
fi

echo ""
