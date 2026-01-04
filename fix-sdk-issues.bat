@echo off
echo ========================================
echo Flutter SDK Issues Fix Script
echo ========================================
echo.

echo [1/5] Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo ERROR: Flutter not found in PATH
    echo Please add Flutter to your PATH
    pause
    exit /b 1
)
echo OK: Flutter is installed
echo.

echo [2/5] Checking Android SDK...
if exist "%LOCALAPPDATA%\Android\Sdk" (
    echo OK: Android SDK found at %LOCALAPPDATA%\Android\Sdk
    set ANDROID_SDK=%LOCALAPPDATA%\Android\Sdk
) else (
    echo ERROR: Android SDK not found
    echo Please install Android SDK
    pause
    exit /b 1
)
echo.

echo [3/5] Configuring Flutter Android SDK...
flutter config --android-sdk "%ANDROID_SDK%"
if errorlevel 1 (
    echo ERROR: Failed to configure Android SDK
    pause
    exit /b 1
)
echo OK: Flutter Android SDK configured
echo.

echo [4/5] Verifying local.properties...
if not exist "android\local.properties" (
    echo Creating local.properties...
    (
        echo sdk.dir=%ANDROID_SDK:\=/%
        echo flutter.sdk=%FLUTTER_ROOT:\=/%
    ) > android\local.properties
) else (
    echo Updating local.properties...
    (
        echo sdk.dir=%ANDROID_SDK:\=/%
        echo flutter.sdk=%FLUTTER_ROOT:\=/%
        echo flutter.buildMode=debug
        echo flutter.versionName=1.0.0
        echo flutter.versionCode=1
    ) > android\local.properties
)
echo OK: local.properties updated
echo.

echo [5/5] Running Flutter Doctor...
flutter doctor -v
echo.

echo ========================================
echo SDK Configuration Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Restart IntelliJ IDEA
echo 2. File -^> Settings -^> Languages ^& Frameworks -^> Flutter
echo 3. Verify Android SDK path: %ANDROID_SDK%
echo 4. Click Apply -^> OK
echo 5. Try running your tests again
echo.
pause

