@echo off
REM Semicolon 개발 모드 시작 스크립트 (Windows)
REM 이 스크립트는 백엔드와 프론트엔드를 개발 모드로 동시에 실행합니다.

echo ==========================================
echo Semicolon Development Mode
echo ==========================================
echo.

REM 현재 디렉토리를 프로젝트 루트로 설정
cd /d "%~dp0"
set PROJECT_ROOT=%CD%

echo 프로젝트 루트: %PROJECT_ROOT%
echo.

REM Python 가상환경 확인
echo [1/3] Python 환경 확인...
cd "%PROJECT_ROOT%\backend"

if not exist "venv\" (
    echo 가상환경을 생성합니다...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -q -e .
) else (
    call venv\Scripts\activate.bat
)

echo [✓] Python 환경 준비 완료
echo.

REM Node.js 패키지 확인
echo [2/3] Node.js 환경 확인...
cd "%PROJECT_ROOT%\frontend"

if not exist "node_modules\" (
    echo Node.js 의존성을 설치합니다...
    call npm install
)

echo [✓] Node.js 환경 준비 완료
echo.

REM 서버 시작
echo [3/3] 개발 서버 시작...
echo.

REM 백엔드 시작
cd "%PROJECT_ROOT%\backend"
start "Semicolon Backend (Dev)" cmd /k "call venv\Scripts\activate.bat && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"

REM 프론트엔드 시작
cd "%PROJECT_ROOT%\frontend"
start "Semicolon Frontend (Dev)" cmd /k "npm run dev -- --host 0.0.0.0 --port 3000"

echo.
echo ==========================================
echo 개발 서버가 시작되었습니다!
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
