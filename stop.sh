#!/bin/bash

# Semicolon 서버 중지 스크립트 (Linux/Mac)

set -e

echo "=========================================="
echo "Semicolon Server Stop Script"
echo "=========================================="

# 색상 코드
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 현재 디렉토리를 프로젝트 루트로 설정
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

# PID 파일 확인 및 프로세스 종료
if [ -f "${PROJECT_ROOT}/backend.pid" ]; then
    BACKEND_PID=$(cat "${PROJECT_ROOT}/backend.pid")
    echo -e "${BLUE}백엔드 서버 중지 (PID: ${BACKEND_PID})...${NC}"
    
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo -e "${GREEN}✓ 백엔드 서버가 중지되었습니다.${NC}"
    else
        echo -e "${RED}백엔드 프로세스가 이미 종료되었습니다.${NC}"
    fi
    
    rm -f "${PROJECT_ROOT}/backend.pid"
else
    echo -e "${RED}백엔드 PID 파일을 찾을 수 없습니다.${NC}"
fi

echo ""

if [ -f "${PROJECT_ROOT}/frontend.pid" ]; then
    FRONTEND_PID=$(cat "${PROJECT_ROOT}/frontend.pid")
    echo -e "${BLUE}프론트엔드 서버 중지 (PID: ${FRONTEND_PID})...${NC}"
    
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✓ 프론트엔드 서버가 중지되었습니다.${NC}"
    else
        echo -e "${RED}프론트엔드 프로세스가 이미 종료되었습니다.${NC}"
    fi
    
    rm -f "${PROJECT_ROOT}/frontend.pid"
else
    echo -e "${RED}프론트엔드 PID 파일을 찾을 수 없습니다.${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}서버가 중지되었습니다.${NC}"
echo "=========================================="
