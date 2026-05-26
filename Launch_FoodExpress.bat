@echo off
echo ==========================================
echo       Launching FoodExpress App...
echo ==========================================

:: Start Backend
echo Starting Backend Server...
start cmd /k "cd backend && npm run dev"

:: Start Frontend
echo Starting Frontend Server...
start cmd /k "cd frontend && npm run dev"

:: Wait for servers to initialize
echo Waiting for servers to start...
timeout /t 5 /nobreak > nul

:: Open Website
echo Opening FoodExpress in your browser...
start http://localhost:5175

echo ==========================================
echo   App is running! Keep this window open.
echo ==========================================
pause
