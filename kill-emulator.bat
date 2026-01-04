@echo off
echo ========================================
echo Killing all Android Emulator processes
echo ========================================
echo.

echo Stopping ADB server...
adb kill-server

echo Killing emulator processes...
taskkill /F /IM qemu-system-x86_64.exe 2>nul
taskkill /F /IM emulator.exe 2>nul
taskkill /F /IM emulator-arm.exe 2>nul

echo.
echo Done! You can now start a fresh emulator.
echo.
pause

