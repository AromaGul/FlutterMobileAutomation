@echo off
echo ========================================
echo Force Running Tests on Android Emulator
echo ========================================
echo.

echo [1/3] Checking available devices...
flutter devices
echo.

echo [2/3] Finding Android emulator...
for /f "tokens=2" %%i in ('flutter devices ^| findstr "emulator"') do (
    set EMULATOR_ID=%%i
    echo Found emulator: %%i
    goto :found
)
echo No emulator found. Starting Pixel_7...
flutter emulators --launch Pixel_7
timeout /t 30 /nobreak >nul
for /f "tokens=2" %%i in ('flutter devices ^| findstr "emulator"') do (
    set EMULATOR_ID=%%i
    echo Found emulator: %%i
    goto :found
)

:found
if "%EMULATOR_ID%"=="" (
    echo ERROR: No Android emulator found!
    echo Please start an emulator manually.
    pause
    exit /b 1
)

echo.
echo [3/3] Running tests on %EMULATOR_ID%...
echo.
flutter test integration_test/all_scenarios_pom.dart -d %EMULATOR_ID% --timeout=10m

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Tests completed successfully!
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Tests failed. Check the output above.
    echo ========================================
)

echo.
pause

