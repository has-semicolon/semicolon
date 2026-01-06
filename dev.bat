@echo off
REM Semicolon Development Mode Script (Windows)
REM This script runs both backend and frontend in development mode

echo ==========================================
echo Semicolon Development Mode
echo ==========================================
echo.

REM Set current directory as project root
cd /d "%~dp0"
set PROJECT_ROOT=%CD%

echo Project root: %PROJECT_ROOT%
echo.

REM Check Python virtual environment
echo [1/3] Checking Python environment...
cd "%PROJECT_ROOT%\backend"

if not exist "venv\" (
    echo Creating virtual environment...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -q -e .
) else (
    call venv\Scripts\activate.bat
)

echo [OK] Python environment ready
echo.

REM Check Node.js packages
echo [2/3] Checking Node.js environment...
cd "%PROJECT_ROOT%\frontend"

if not exist "node_modules\" (
    echo Installing Node.js dependencies...
    call npm install
)

echo [OK] Node.js environment ready
echo.

REM Start servers
echo [3/3] Starting development servers...
echo.

REM Start backend
cd "%PROJECT_ROOT%\backend"
start "Semicolon Backend (Dev)" cmd /k "call venv\Scripts\activate.bat && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"

REM Start frontend
cd "%PROJECT_ROOT%\frontend"
start "Semicolon Frontend (Dev)" cmd /k "npm run dev -- --host 0.0.0.0 --port 3000"

echo.
echo ==========================================
echo Development servers started!
echo ==========================================
echo.
echo Service URLs:
echo   - Frontend: http://localhost:3000
echo   - Backend API: http://localhost:8000
echo   - API Docs: http://localhost:8000/docs
echo.
echo Each server runs in a separate terminal window.
echo To stop servers, close each terminal window.
echo.
pause
