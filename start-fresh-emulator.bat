@echo off
echo ========================================
echo Starting Fresh Android Emulator
echo ========================================
echo.

echo [1/3] Closing all existing emulators...
taskkill /F /IM qemu-system-x86_64.exe 2>nul
taskkill /F /IM emulator.exe 2>nul
adb kill-server
timeout /t 3 /nobreak >nul

echo [2/3] Restarting ADB...
adb start-server
timeout /t 2 /nobreak >nul

echo [3/3] Starting fresh emulator...
echo.
echo Available emulators:
echo 1. Medium_Phone_API_36.1
echo 2. Pixel_6
echo 3. Pixel_7
echo.
set /p choice="Select emulator (1-3, default is 2 for Pixel_6): "

if "%choice%"=="1" (
    echo Starting Medium_Phone_API_36.1...
    flutter emulators --launch Medium_Phone_API_36.1
) else if "%choice%"=="3" (
    echo Starting Pixel_7...
    flutter emulators --launch Pixel_7
) else (
    echo Starting Pixel_6...
    flutter emulators --launch Pixel_6
)

echo.
echo Waiting for emulator to boot (this may take 30-60 seconds)...
timeout /t 10 /nobreak >nul

echo.
echo Checking device status...
adb devices

echo.
echo Emulator should be starting. Wait for it to fully boot before running tests.
echo.
pause


