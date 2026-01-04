@echo off
echo ========================================
echo Running Flutter Integration Tests on Android Emulator
echo ========================================
echo.

echo [1/3] Checking for connected Android devices...
adb devices
echo.

echo [2/3] Checking available devices...
flutter devices
echo.

echo [3/3] Running integration tests on Android emulator...
echo.
echo This will run all scenarios on the Android emulator (emulator-5554 or emulator-5556)
echo.

REM Run tests on Android device
flutter test integration_test/all_scenarios_pom.dart -d emulator-5554

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

