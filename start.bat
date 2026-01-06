@echo off
REM Semicolon 서버 시작 스크립트 (Windows)
REM 이 스크립트는 백엔드와 프론트엔드를 동시에 실행합니다.

echo ==========================================
echo Semicolon Server Startup Script
echo ==========================================
echo.

REM 현재 디렉토리를 프로젝트 루트로 설정
cd /d "%~dp0"
set PROJECT_ROOT=%CD%

echo 프로젝트 루트: %PROJECT_ROOT%
echo.

REM Python 가상환경 확인 및 생성
echo [1/5] Python 환경 설정...
cd "%PROJECT_ROOT%\backend"

if not exist "venv\" (
    echo 가상환경을 생성합니다...
    python -m venv venv
)

REM 가상환경 활성화
call venv\Scripts\activate.bat

REM Python 패키지 설치
echo Python 의존성을 설치합니다...
pip install -q -e .

echo [✓] Python 환경 설정 완료
echo.

REM Node.js 패키지 설치
echo [2/5] Node.js 환경 설정...
cd "%PROJECT_ROOT%\frontend"

if not exist "node_modules\" (
    echo Node.js 의존성을 설치합니다...
    call npm install
) else (
    echo Node.js 의존성이 이미 설치되어 있습니다.
)

echo [✓] Node.js 환경 설정 완료
echo.

REM 프론트엔드 빌드
echo [3/5] 프론트엔드 빌드...
call npm run build
echo [✓] 프론트엔드 빌드 완료
echo.

REM 백엔드 시작
echo [4/5] 백엔드 서버 시작...
cd "%PROJECT_ROOT%\backend"

REM 새 터미널 창에서 백엔드 실행
start "Semicolon Backend" cmd /k "call venv\Scripts\activate.bat && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"
echo [✓] 백엔드 서버: http://localhost:8000
echo.

REM 프론트엔드 시작
echo [5/5] 프론트엔드 서버 시작...
cd "%PROJECT_ROOT%\frontend"

REM 새 터미널 창에서 프론트엔드 실행
start "Semicolon Frontend" cmd /k "npm run preview -- --host 0.0.0.0 --port 3000"
echo [✓] 프론트엔드 서버: http://localhost:3000
echo.

echo ==========================================
echo 서버가 성공적으로 시작되었습니다!
echo ==========================================
echo.
echo 서비스 URL:
echo   - 프론트엔드: http://localhost:3000
echo   - 백엔드 API: http://localhost:8000
echo   - API 문서: http://localhost:8000/docs
echo.
echo 각 서버는 별도의 터미널 창에서 실행됩니다.
echo 서버를 중지하려면 각 터미널 창을 닫으세요.
echo.
pause
