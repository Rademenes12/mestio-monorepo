# Running FixFlow App

## Prerequisites
- Flutter SDK 3.44.2+
- Android Studio with Android SDK
- Android Emulator or physical device

## Running the App

### Method 1: Using VS Code (Recommended)
1. Open the project in VS Code
2. Select the device from the device selector
3. Press F5 or use the "Run and Debug" panel
4. Select "Debug mode" or "Release mode" configuration

**Note:** VS Code launch configuration already includes `--dart-define-from-file=config/api-keys.json`

### Method 2: Using Command Line
```bash
flutter run -d <device-id> --dart-define-from-file=config/api-keys.json
```

For Android emulator:
```bash
flutter run -d emulator-5554 --dart-define-from-file=config/api-keys.json
```

**IMPORTANT:** Always include `--dart-define-from-file=config/api-keys.json` when running from command line, otherwise the app will not have Supabase API keys and will show a "Missing API Keys" screen.

## Checking Available Devices
```bash
flutter devices
```

## Clearing App Data (Fresh Start)
If you want to test the app from a clean state (no persisted login):

### Android
```bash
adb shell pm clear com.pawelpasik.fixflow
```

### iOS
Long press the app icon and select "Delete App", then reinstall.

## Common Issues

### Issue: Black screen or app doesn't start
**Solution:** Make sure you're running with API keys:
```bash
flutter run -d emulator-5554 --dart-define-from-file=config/api-keys.json
```

### Issue: App shows "Missing Supabase Keys" screen
**Solution:** You forgot to include `--dart-define-from-file=config/api-keys.json` parameter.

### Issue: App goes directly to HomeScreen instead of WelcomeScreen
**Cause:** The app has persisted an anonymous guest session from a previous run.
**Solution:** Clear app data (see above) to test the welcome flow again.

## Hot Reload / Hot Restart
- Press `r` in the terminal for hot reload
- Press `R` in the terminal for hot restart
- Press `q` to quit

## Debug Logs
The app includes extensive debug logging for session flow and UI rendering:
- `[SessionRepository]` - Session state management
- `[SessionCubit]` - Session state emissions
- `[AppGate]` - Routing decisions
- `[WelcomeScreen]` / `[HomeScreen]` - UI rendering

View logs with:
```bash
# Android
adb logcat -s flutter:I

# Or filter for specific component
adb logcat -s flutter:I | grep Session
```

## Build Commands

### Android APK (Debug)
```bash
flutter build apk --debug --dart-define-from-file=config/api-keys.json
```

### Android APK (Release)
```bash
flutter build apk --release --dart-define-from-file=config/api-keys.json
```

### iOS (requires macOS)
```bash
flutter build ios --release --dart-define-from-file=config/api-keys.json
```
