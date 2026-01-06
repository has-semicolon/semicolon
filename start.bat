@echo off
REM Semicolon Server Startup Script (Windows)
REM This script runs both backend and frontend servers

echo ==========================================
echo Semicolon Server Startup Script
echo ==========================================
echo.

REM Set current directory as project root
cd /d "%~dp0"
set PROJECT_ROOT=%CD%

echo Project root: %PROJECT_ROOT%
echo.

REM Check and create Python virtual environment
echo [1/5] Setting up Python environment...
cd "%PROJECT_ROOT%\backend"

if not exist "venv\" (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install Python packages
echo Installing Python dependencies...
pip install -q -e .

echo [OK] Python environment ready
echo.

REM Install Node.js packages
echo [2/5] Setting up Node.js environment...
cd "%PROJECT_ROOT%\frontend"

if not exist "node_modules\" (
    echo Installing Node.js dependencies...
    call npm install
) else (
    echo Node.js dependencies already installed.
)

echo [OK] Node.js environment ready
echo.

REM Build frontend
echo [3/5] Building frontend...
call npm run build
echo [OK] Frontend build complete
echo.

REM Start backend
echo [4/5] Starting backend server...
cd "%PROJECT_ROOT%\backend"

REM Run backend in new terminal window
start "Semicolon Backend" cmd /k "call venv\Scripts\activate.bat && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"
echo [OK] Backend server: http://localhost:8000
echo.

REM Start frontend
echo [5/5] Starting frontend server...
cd "%PROJECT_ROOT%\frontend"

REM Run frontend in new terminal window
start "Semicolon Frontend" cmd /k "npm run preview -- --host 0.0.0.0 --port 3000"
echo [OK] Frontend server: http://localhost:3000
echo.

echo ==========================================
echo Servers started successfully!
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
