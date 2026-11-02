@echo off
title InternPortal - React Frontend
echo ========================================================
echo   Starting InternPortal - Online Internship System
echo ========================================================
set "PATH=%LOCALAPPDATA%\Programs\node-portable;%PATH%"
cd /d "%~dp0frontend"

echo Opening browser at http://localhost:3000 ...
start http://localhost:3000

npm run dev -- --host 127.0.0.1 --port 3000
pause
