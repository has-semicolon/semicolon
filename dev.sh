#!/bin/bash

# Semicolon 개발 모드 시작 스크립트 (Linux/Mac)
# 이 스크립트는 백엔드와 프론트엔드를 개발 모드로 동시에 실행합니다.

set -e

echo "=========================================="
echo "Semicolon Development Mode"
echo "=========================================="

# 색상 코드
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 현재 디렉토리를 프로젝트 루트로 설정
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

echo -e "${BLUE}프로젝트 루트: ${PROJECT_ROOT}${NC}"
echo ""

# Python 가상환경 확인
echo -e "${BLUE}[1/3] Python 환경 확인...${NC}"
cd "${PROJECT_ROOT}/backend"

if [ ! -d "venv" ]; then
    echo "가상환경을 생성합니다..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -q -e .
else
    source venv/bin/activate
fi

echo -e "${GREEN}✓ Python 환경 준비 완료${NC}"
echo ""

# Node.js 패키지 확인
echo -e "${BLUE}[2/3] Node.js 환경 확인...${NC}"
cd "${PROJECT_ROOT}/frontend"

if [ ! -d "node_modules" ]; then
    echo "Node.js 의존성을 설치합니다..."
    npm install
fi

echo -e "${GREEN}✓ Node.js 환경 준비 완료${NC}"
echo ""

# 서버 시작
echo -e "${BLUE}[3/3] 개발 서버 시작...${NC}"
echo ""

# tmux 또는 screen이 있는지 확인
if command -v tmux &> /dev/null; then
    echo "tmux를 사용하여 서버를 시작합니다..."
    echo "세션에 연결하려면: tmux attach -t semicolon"
    
    # 기존 세션이 있으면 종료
    tmux kill-session -t semicolon 2>/dev/null || true
    
    # 새 세션 시작
    tmux new-session -d -s semicolon
    
    # 백엔드 창
    tmux send-keys -t semicolon "cd ${PROJECT_ROOT}/backend && source venv/bin/activate && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload" C-m
    
    # 프론트엔드 창 생성
    tmux split-window -h -t semicolon
    tmux send-keys -t semicolon "cd ${PROJECT_ROOT}/frontend && npm run dev -- --host 0.0.0.0 --port 3000" C-m
    
    echo ""
    echo -e "${GREEN}개발 서버가 시작되었습니다!${NC}"
    echo ""
    echo "서비스 URL:"
    echo "  - 프론트엔드: http://localhost:3000"
    echo "  - 백엔드 API: http://localhost:8000"
    echo "  - API 문서: http://localhost:8000/docs"
    echo ""
    echo "tmux 세션에 연결: tmux attach -t semicolon"
    echo "tmux에서 나가기: Ctrl+B, D"
    echo "세션 종료: tmux kill-session -t semicolon"
    
else
    echo "백엔드와 프론트엔드를 백그라운드에서 시작합니다..."
    
    # 백엔드 시작
    cd "${PROJECT_ROOT}/backend"
    nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload > backend-dev.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > "${PROJECT_ROOT}/backend-dev.pid"
    
    # 프론트엔드 시작
    cd "${PROJECT_ROOT}/frontend"
    nohup npm run dev -- --host 0.0.0.0 --port 3000 > frontend-dev.log 2>&1 &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > "${PROJECT_ROOT}/frontend-dev.pid"
    
    echo ""
    echo -e "${GREEN}개발 서버가 시작되었습니다!${NC}"
    echo ""
    echo "서비스 URL:"
    echo "  - 프론트엔드: http://localhost:3000"
    echo "  - 백엔드 API: http://localhost:8000"
    echo "  - API 문서: http://localhost:8000/docs"
    echo ""
    echo "로그 파일:"
    echo "  - 백엔드: ${PROJECT_ROOT}/backend/backend-dev.log"
    echo "  - 프론트엔드: ${PROJECT_ROOT}/frontend/frontend-dev.log"
    echo ""
    echo "로그 보기: tail -f backend/backend-dev.log"
    echo "          tail -f frontend/frontend-dev.log"
fi

echo ""
