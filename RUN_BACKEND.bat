@echo off
title InternPortal - Spring Boot Backend
echo ========================================================
echo   Starting InternPortal Spring Boot Server (Port 8080)
echo ========================================================
cd /d "%~dp0backend"

where mvn >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Apache Maven ('mvn') is not found in your PATH.
    echo Please install JDK 17+ and Maven, or open the project in
    echo IntelliJ IDEA / Eclipse and click 'Run InternPortalApplication'.
    echo.
    echo Note: The Frontend is already fully working and can be used
    echo independently by running RUN_FRONTEND.bat!
    pause
    exit /b 1
)

mvn clean spring-boot:run
pause
