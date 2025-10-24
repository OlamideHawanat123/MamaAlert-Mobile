# 🚀 MamaAlert - Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Install Flutter (Skip if already installed)

**Check if Flutter is installed:**
```bash
flutter --version
```

**If not installed, download from:** https://flutter.dev/docs/get-started/install

---

### Step 2: Install Dependencies

Open terminal in project folder and run:

```bash
cd c:\Users\rahee\Desktop\mama_alert_app
flutter pub get
```

**Expected output:**
```
Running "flutter pub get" in mama_alert_app...
Resolving dependencies...
Got dependencies!
```

---

### Step 3: Configure Backend URL

**Edit file:** `lib/config/api_config.dart`

**Change line 10:**
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

**To your backend URL:**
```dart
static const String baseUrl = 'http://YOUR_IP:8080/api';
```

**Examples:**
- Local: `http://localhost:8080/api`
- Network: `http://192.168.1.100:8080/api`
- Production: `https://api.mamaalert.com/api`

**💡 Tip:** To find your IP:
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

---

### Step 4: Run the App

**Connect a device or start an emulator, then:**

```bash
flutter run
```

**That's it! 🎉**

---

## 📱 Testing the App

### 1. Login
- Email: Use credentials from your backend
- Password: Your password

### 2. Test Emergency Alert
- Go to Home screen
- Press the big red "EMERGENCY ALERT" button
- Confirm the alert
- Check backend logs for SMS notifications

### 3. Add Appointment
- Tap "Add Appointment" button
- Fill in the form
- Save

### 4. Log Health Data
- Tap "Log Health" button
- Enter weight, BP, etc.
- Save

---

## 🔧 Troubleshooting

### Error: "Connection refused"
**Solution:** 
- Make sure backend is running
- Check IP address is correct
- Use `10.0.2.2` for Android Emulator instead of `localhost`

### Error: "Pub get failed"
**Solution:**
```bash
flutter clean
flutter pub get
```

### Error: "No devices found"
**Solution:**
- Start Android Emulator in Android Studio
- Or connect physical device with USB debugging enabled

### Backend not responding
**Solution:**
```bash
# Test backend manually
curl http://YOUR_BACKEND_URL/actuator/health
```

---

## 📚 Important Files

| File | Purpose |
|------|---------|
| `lib/config/api_config.dart` | Backend URL configuration |
| `lib/services/emergency_service.dart` | Emergency alert API |
| `lib/screens/emergency_alert_screen.dart` | Emergency UI |
| `README.md` | Full documentation |
| `SETUP.md` | Detailed setup guide |

---

## 🎯 Key Features to Test

- ✅ Login/Logout
- ✅ Emergency Alert (10-min cooldown)
- ✅ Appointment Management
- ✅ Health Tracking with Charts
- ✅ Pregnancy Week Progress
- ✅ Educational Content
- ✅ Profile Management

---

## 🚑 Emergency Alert Flow

```
1. User presses Emergency Button
         ↓
2. Confirmation Dialog
         ↓
3. GPS Location Captured
         ↓
4. API Call: POST /emergency-alerts
         ↓
5. Backend sends SMS to:
   - Emergency Contact (Relative)
   - All Drivers within 10km
         ↓
6. Success Message Shown
```

---

## 📞 Need Help?

1. **Read Documentation:**
   - `README.md` - Overview
   - `SETUP.md` - Detailed setup
   - `FILES_GENERATED.md` - File structure

2. **Check Logs:**
```bash
flutter run -v  # Verbose output
```

3. **Test Backend:**
```bash
curl -X POST http://YOUR_BACKEND_URL/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test"}'
```

---

## 🎨 Customization

### Change App Colors
**File:** `lib/main.dart` (Line 31-35)
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFE91E63), // Change this!
),
```

### Change App Name
**File:** `android/app/src/main/AndroidManifest.xml`
```xml
android:label="Your App Name"
```

---

## ✅ Checklist Before Going Live

- [ ] Backend URL configured correctly
- [ ] Tested login functionality
- [ ] Tested emergency alert
- [ ] Verified SMS notifications work
- [ ] Tested on physical device
- [ ] Location permissions granted
- [ ] Notification permissions granted
- [ ] App icon customized
- [ ] App name set
- [ ] Privacy policy added
- [ ] Terms of service added

---

## 🚀 Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

**Install on device:**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 💡 Pro Tips

1. **Hot Reload**: Press `r` in terminal while app is running to see changes instantly
2. **Hot Restart**: Press `R` for full restart
3. **Logs**: Press `l` to see logs
4. **Clear Cache**: Run `flutter clean` if you face weird errors
5. **Update Packages**: Run `flutter pub upgrade` periodically

---

**Ready to save lives! 🚑💚**

For detailed documentation, see `README.md` and `SETUP.md`

---

Last Updated: October 23, 2025
