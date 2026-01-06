#!/bin/bash

# Semicolon 서버 시작 스크립트 (Linux/Mac)
# 이 스크립트는 백엔드와 프론트엔드를 동시에 실행합니다.

set -e

echo "=========================================="
echo "Semicolon Server Startup Script"
echo "=========================================="

# 색상 코드
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 현재 디렉토리를 프로젝트 루트로 설정
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

echo -e "${BLUE}프로젝트 루트: ${PROJECT_ROOT}${NC}"
echo ""

# Python 가상환경 확인 및 생성
echo -e "${BLUE}[1/5] Python 환경 설정...${NC}"
cd "${PROJECT_ROOT}/backend"

if [ ! -d "venv" ]; then
    echo "가상환경을 생성합니다..."
    python3 -m venv venv
fi

# 가상환경 활성화
source venv/bin/activate

# Python 패키지 설치
echo "Python 의존성을 설치합니다..."
pip install -q -e .

echo -e "${GREEN}✓ Python 환경 설정 완료${NC}"
echo ""

# Node.js 패키지 설치
echo -e "${BLUE}[2/5] Node.js 환경 설정...${NC}"
cd "${PROJECT_ROOT}/frontend"

if [ ! -d "node_modules" ]; then
    echo "Node.js 의존성을 설치합니다..."
    npm install
else
    echo "Node.js 의존성이 이미 설치되어 있습니다."
fi

echo -e "${GREEN}✓ Node.js 환경 설정 완료${NC}"
echo ""

# 프론트엔드 빌드
echo -e "${BLUE}[3/5] 프론트엔드 빌드...${NC}"
npm run build
echo -e "${GREEN}✓ 프론트엔드 빌드 완료${NC}"
echo ""

# 백엔드 시작
echo -e "${BLUE}[4/5] 백엔드 서버 시작...${NC}"
cd "${PROJECT_ROOT}/backend"

# 백그라운드에서 백엔드 실행
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload > backend.log 2>&1 &
BACKEND_PID=$!
echo "백엔드 서버가 PID ${BACKEND_PID}로 시작되었습니다."
echo -e "${GREEN}✓ 백엔드 서버: http://localhost:8000${NC}"
echo ""

# 프론트엔드 시작
echo -e "${BLUE}[5/5] 프론트엔드 서버 시작...${NC}"
cd "${PROJECT_ROOT}/frontend"

# 프론트엔드 프리뷰 서버 시작
nohup npm run preview -- --host 0.0.0.0 --port 3000 > frontend.log 2>&1 &
FRONTEND_PID=$!
echo "프론트엔드 서버가 PID ${FRONTEND_PID}로 시작되었습니다."
echo -e "${GREEN}✓ 프론트엔드 서버: http://localhost:3000${NC}"
echo ""

# PID 파일 저장
echo $BACKEND_PID > "${PROJECT_ROOT}/backend.pid"
echo $FRONTEND_PID > "${PROJECT_ROOT}/frontend.pid"

echo "=========================================="
echo -e "${GREEN}서버가 성공적으로 시작되었습니다!${NC}"
echo "=========================================="
echo ""
echo "서비스 URL:"
echo "  - 프론트엔드: http://localhost:3000"
echo "  - 백엔드 API: http://localhost:8000"
echo "  - API 문서: http://localhost:8000/docs"
echo ""
echo "로그 파일:"
echo "  - 백엔드: ${PROJECT_ROOT}/backend/backend.log"
echo "  - 프론트엔드: ${PROJECT_ROOT}/frontend/frontend.log"
echo ""
echo "서버를 중지하려면: ./stop.sh"
echo ""
