# MamaAlert App - Setup & Configuration Guide

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Backend Configuration](#backend-configuration)
4. [Running the App](#running-the-app)
5. [API Integration](#api-integration)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software
- **Flutter SDK**: Version 3.0 or higher
- **Dart SDK**: Comes with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### Check Flutter Installation
```bash
flutter doctor
```

### Install Flutter (if not installed)

**Windows:**
1. Download Flutter SDK from https://flutter.dev
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor`

**macOS/Linux:**
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

## Installation

### Step 1: Clone or Navigate to Project
```bash
cd c:\Users\rahee\Desktop\mama_alert_app
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

This will install all packages listed in `pubspec.yaml`:
- `provider` - State management
- `shared_preferences` - Local storage
- `http` - API calls
- `flutter_local_notifications` - Push notifications
- `geolocator` - GPS location
- `geocoding` - Address lookup
- `fl_chart` - Health charts
- `intl` - Date/time formatting
- `permission_handler` - Runtime permissions

### Step 3: Verify Installation
```bash
flutter doctor -v
```

Ensure all checkmarks are green for your target platform.

## Backend Configuration

### Update API Base URL

**File**: `lib/config/api_config.dart`

```dart
class ApiConfig {
  // Change this to your backend URL
  static const String baseUrl = 'YOUR_BACKEND_URL';
}
```

### Configuration Examples

**Local Development (Backend on same machine):**
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

**Local Network (Backend on another device):**
```dart
static const String baseUrl = 'http://192.168.1.100:8080/api';
// Replace 192.168.1.100 with your backend machine's IP
```

**Production Server:**
```dart
static const String baseUrl = 'https://api.mamaalert.com/api';
```

### Find Your Local IP (for testing on physical device)

**Windows:**
```bash
ipconfig
# Look for IPv4 Address under your active network adapter
```

**macOS/Linux:**
```bash
ifconfig | grep "inet "
# or
ip addr show
```

### Update Services

The base URL is used in:
1. `lib/services/emergency_service.dart`
2. `lib/services/auth_service.dart`

Both import from `lib/config/api_config.dart`.

## Running the App

### Run on Emulator/Simulator

**Android Emulator:**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

**iOS Simulator (macOS only):**
```bash
open -a Simulator
flutter run
```

### Run on Physical Device

#### Android Device

1. **Enable Developer Options:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging:**
   - Settings → Developer Options
   - Enable "USB Debugging"

3. **Connect via USB and run:**
```bash
flutter devices  # Verify device is connected
flutter run
```

#### iOS Device (macOS only)

1. Connect iPhone via USB
2. Trust the computer
3. Open Xcode and sign the app
4. Run:
```bash
flutter run
```

### Build APK for Distribution

**Debug APK:**
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

**Release APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**App Bundle (for Google Play):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

## API Integration

### Backend Requirements

Ensure your Spring Boot backend is running and accessible.

**Check backend health:**
```bash
curl http://YOUR_BACKEND_URL/actuator/health
```

### API Endpoints Used

#### 1. Authentication
```http
POST /auth/login
Content-Type: application/json

{
  "email": "patient@example.com",
  "password": "password123"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "role": "PATIENT",
  "userId": "123"
}
```

#### 2. Trigger Emergency Alert
```http
POST /emergency-alerts
Authorization: Bearer <token>
Content-Type: application/json

{
  "patientId": "123",
  "latitude": 9.0820,
  "longitude": 8.6753
}

Response: 201 Created
{
  "id": "alert123",
  "status": "PENDING",
  "notifiedDrivers": [...],
  "timestamp": "2025-10-23T10:30:00"
}

Error: 429 Too Many Requests (if within 10-min cooldown)
{
  "message": "Please wait 10 minutes before triggering another alert"
}
```

#### 3. Get Emergency History
```http
GET /emergency-alerts/history
Authorization: Bearer <token>

Response: 200 OK
[
  {
    "id": "alert123",
    "status": "RESOLVED",
    "triggeredAt": "2025-10-23T10:30:00",
    "resolvedAt": "2025-10-23T11:00:00"
  }
]
```

### Test API Connection

**File**: `lib/services/emergency_service.dart`

Add debug logging:
```dart
try {
  final response = await http.post(...);
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
} catch (e) {
  print('Error: $e');
}
```

## Troubleshooting

### Common Issues

#### 1. "Unable to connect to backend"

**Solution:**
- Verify backend is running: `curl http://YOUR_BACKEND_URL`
- Check firewall settings
- For emulator, use `10.0.2.2` instead of `localhost`
- For physical device, ensure both devices are on same WiFi

**Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

#### 2. "Pub get failed"

**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

#### 3. "Location permissions denied"

**Solution:**
- Check `AndroidManifest.xml` has location permissions
- Request runtime permissions (already implemented in app)
- For iOS, add to `Info.plist`

#### 4. "Notifications not showing"

**Solution:**
- Android 13+: Request POST_NOTIFICATIONS permission
- Check notification service initialization in `main.dart`
- Verify channel setup in `notification_service.dart`

#### 5. "Build fails"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

#### 6. "Hot reload not working"

**Solution:**
- Press 'r' in terminal for hot reload
- Press 'R' for hot restart
- Or click the lightning icon in VS Code/Android Studio

### Platform-Specific Issues

**Android:**
```bash
# Clear Gradle cache
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

**iOS:**
```bash
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter run
```

### Network Debugging

**Enable verbose logging:**
```bash
flutter run -v
```

**Check network requests:**
Use tools like:
- Charles Proxy
- Postman for API testing
- Browser DevTools Network tab

### Backend Connection Test

Create a test file: `test_connection.dart`
```dart
import 'package:http/http.dart' as http;

void main() async {
  final url = 'http://YOUR_BACKEND_URL/auth/login';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: '{"email":"test@test.com","password":"test"}',
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
```

Run:
```bash
dart test_connection.dart
```

## Environment Setup

### Development
```dart
// lib/config/api_config.dart
static const String baseUrl = 'http://localhost:8080/api';
```

### Staging
```dart
static const String baseUrl = 'https://staging-api.mamaalert.com/api';
```

### Production
```dart
static const String baseUrl = 'https://api.mamaalert.com/api';
```

## Testing Credentials

For testing, use credentials provided by your backend team:
```
Email: patient@example.com
Password: password123
```

## Next Steps

1. ✅ Install Flutter SDK
2. ✅ Run `flutter pub get`
3. ✅ Configure backend URL
4. ✅ Test backend connectivity
5. ✅ Run app on emulator/device
6. ✅ Test login functionality
7. ✅ Test emergency alert feature

## Support

For issues:
1. Check this documentation
2. Review error messages carefully
3. Search Flutter documentation
4. Contact backend team for API issues

---

**Last Updated**: October 23, 2025
