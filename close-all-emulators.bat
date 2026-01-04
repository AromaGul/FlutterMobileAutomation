@echo off
echo ========================================
echo Closing All Android Emulators
echo ========================================
echo.

echo [1/3] Stopping ADB server...
adb kill-server
timeout /t 2 /nobreak >nul

echo [2/3] Killing emulator processes...
taskkill /F /IM qemu-system-x86_64.exe 2>nul
taskkill /F /IM emulator.exe 2>nul
taskkill /F /IM emulator-arm.exe 2>nul
timeout /t 2 /nobreak >nul

echo [3/3] Restarting ADB server...
adb start-server
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo Verification
echo ========================================
adb devices

echo.
echo Done! All emulators have been closed.
echo You can now start a fresh emulator.
echo.
pause


