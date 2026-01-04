# How to Push Code to GitHub

## Repository: https://github.com/AromaGul/FlutterMobileAutomation

---

## Step-by-Step Guide

### Step 1: Initialize Git (If Not Already Done)

```bash
cd C:\Users\vend.it\Desktop\mobile_assignment_flutter
git init
```

### Step 2: Add Remote Repository

```bash
git remote add origin https://github.com/AromaGul/FlutterMobileAutomation.git
```

Or if remote already exists, update it:
```bash
git remote set-url origin https://github.com/AromaGul/FlutterMobileAutomation.git
```

### Step 3: Create .gitignore (If Not Exists)

Create `.gitignore` file with:
```
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
*.iml
*.ipr
*.iws
.idea/

# Android
android/.gradle/
android/local.properties
android/app/debug/
android/app/profile/
android/app/release/

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
ios/Flutter/Generated.xcconfig
ios/Flutter/ephemeral/
ios/Flutter/app.flx
ios/Flutter/app.zip
ios/Flutter/flutter_assets/
ios/ServiceDefinitions.json
ios/Runner/GeneratedPluginRegistrant.*

# Web
web/

# Windows
windows/flutter/ephemeral/

# macOS
macos/Flutter/ephemeral/

# Linux
linux/flutter/ephemeral/

# Coverage
coverage/

# Exceptions
!packages/flutter_tools/test/data/dart_dependencies_test/**/.packages
```

### Step 4: Add All Files

```bash
git add .
```

### Step 5: Commit Files

```bash
git commit -m "Initial commit: Flutter mobile automation project"
```

### Step 6: Push to GitHub

```bash
git branch -M main
git push -u origin main
```

If you get authentication error, use:
```bash
git push -u origin main
```
(You'll be prompted for GitHub username and password/token)

---

## Using GitHub Personal Access Token

If prompted for password, use a **Personal Access Token**:

1. **Go to:** GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. **Generate new token:**
   - Select scopes: `repo` (full control)
   - Generate token
   - Copy token
3. **Use token as password** when pushing

---

## Quick Commands (Copy-Paste)

```bash
# Navigate to project
cd C:\Users\vend.it\Desktop\mobile_assignment_flutter

# Initialize Git (if needed)
git init

# Add remote
git remote add origin https://github.com/AromaGul/FlutterMobileAutomation.git

# Add files
git add .

# Commit
git commit -m "Initial commit: Flutter mobile automation project"

# Push
git branch -M main
git push -u origin main
```

---

## Troubleshooting

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/AromaGul/FlutterMobileAutomation.git
```

### Error: "Authentication failed"
- Use Personal Access Token instead of password
- Or use SSH: `git@github.com:AromaGul/FlutterMobileAutomation.git`

### Error: "Branch main does not exist"
```bash
git checkout -b main
git push -u origin main
```

---

## After Pushing

Your code will be available at:
**https://github.com/AromaGul/FlutterMobileAutomation**

