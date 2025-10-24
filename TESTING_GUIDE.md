# MamaAlert - Testing & Debugging Guide

## ✅ Fixes Applied

### 1. **UI Overflow Fixed**
- Fixed registration selection screen text overflow
- Made title and badge flexible
- Reduced font sizes slightly for better fit
- Added text overflow handling

### 2. **API Call Debugging Enabled**
- Added debug logging to all API calls
- Console will show:
  - Request URL
  - Request body
  - Response status
  - Response body
  - Errors with details

### 3. **Proper Authentication Flow**
- Emergency alert now gets user ID from auth service
- Proper error handling for missing authentication
- Clear error messages displayed

---

## 🧪 How to Test API Calls

### **Watch the Console**

When you perform actions, you'll see debug output in your terminal:

#### **Login Example:**
```
=== LOGIN API CALL ===
URL: http://10.0.2.2:8080/api/auth/login
Email: admin@test.com
Response Status: 200
Response Body: {"token":"eyJhbG...", "role":"SUPER_ADMIN", "userId":"123"}
Login successful! Role: SUPER_ADMIN
```

#### **Emergency Alert Example:**
```
=== EMERGENCY ALERT API CALL ===
URL: http://10.0.2.2:8080/api/emergency-alerts
Body: {"patientId":"123","latitude":9.082,"longitude":8.6753}
Token: eyJhbGciOiJIUzI1NiIs...
Response Status: 201
Response Body: {"id":"alert_123","status":"PENDING",...}
```

---

## 🚀 Complete Testing Flow

### **Step 1: Start Backend**
```bash
# Make sure your Spring Boot backend is running
cd your-backend-project
mvn spring-boot:run
```

Verify it's running: Open browser → `http://localhost:8080`

---

### **Step 2: Watch Flutter Console**

In your PowerShell where `flutter run` is executing, you'll see all debug output.

---

### **Step 3: Test Registration**

1. **Open app** → Login screen
2. **Tap "Register as Super Admin"**
3. **Fill form:**
   - First Name: Test
   - Last Name: Admin
   - Email: test@admin.com
   - Phone: +2348012345678
   - Password: test123
   - Confirm: test123
4. **Tap "Register Super Admin"**

**Watch Console:**
```
=== REGISTER SUPER ADMIN API CALL ===
URL: http://10.0.2.2:8080/api/auth/register/super-admin
Response Status: 201
```

**App Shows:**
- Green snackbar: "Super Admin registered successfully!"
- Returns to login screen

---

### **Step 4: Test Login**

1. **On login screen:**
   - Email: test@admin.com
   - Password: test123
2. **Tap "Login"**

**Watch Console:**
```
=== LOGIN API CALL ===
URL: http://10.0.2.2:8080/api/auth/login
Email: test@admin.com
Response Status: 200
Response Body: {"token":"...", "role":"SUPER_ADMIN", "userId":"abc123"}
Login successful! Role: SUPER_ADMIN
```

**App Shows:**
- Navigates to Super Admin Dashboard
- Shows "Register Hospital" and "Register Driver Admin" buttons

---

### **Step 5: Register Hospital**

1. **From Super Admin Dashboard**
2. **Tap "Register Hospital"**
3. **Fill form**
4. **Submit**

**Watch Console:**
```
=== API CALL ===
URL: http://10.0.2.2:8080/api/hospitals
Response Status: 201
```

---

### **Step 6: Test Emergency Alert**

1. **Logout** → **Login as Patient** (you need to create one first via Hospital dashboard)
2. **Patient Dashboard** appears
3. **Tap big red EMERGENCY button**
4. **Confirm**

**Watch Console:**
```
=== EMERGENCY ALERT API CALL ===
URL: http://10.0.2.2:8080/api/emergency-alerts
Body: {"patientId":"patient123","latitude":9.082,"longitude":8.6753}
Token: eyJhbGci...
Response Status: 201
Response Body: {"id":"alert_xyz","status":"PENDING","notifiedDrivers":[...]}
```

**Watch Backend Console:**
```
POST /api/emergency-alerts
Status: 201
SMS sent to: +234... (relative)
SMS sent to: +234... (driver1)
SMS sent to: +234... (driver2)
```

**App Shows:**
- Success screen with green checkmark
- "Alert Sent Successfully!"
- "Help is on the way!"

---

## ⚠️ Troubleshooting

### **Issue: "Connection refused"**

**Console shows:**
```
Failed: Failed to send emergency alert (Status: 0)
or
Connection refused
```

**Solution:**
1. Check backend is running: `http://localhost:8080`
2. Verify `lib/config/api_config.dart` has `http://10.0.2.2:8080/api`
3. Check emulator can reach host: `adb shell ping 10.0.2.2`

---

### **Issue: "Not authenticated"**

**Console shows:**
```
Response Status: 401
```

**Solution:**
1. Login first
2. Check token is saved (console shows "Login successful!")
3. Try logout and login again

---

### **Issue: "Please wait 10 minutes"**

**Console shows:**
```
Response Status: 429
Please wait 10 minutes before triggering another alert
```

**This is correct!** Your backend's 10-minute cooldown is working.

---

### **Issue: Backend returns error**

**Console shows:**
```
Response Status: 400
Response Body: {"message":"Invalid patient ID"}
```

**Solution:**
1. Check patient exists in backend database
2. Verify user ID is correct (console shows it)
3. Check backend validation rules

---

## 📊 Success Indicators

### **✅ Everything Working:**

1. **Console shows all API calls** with URLs and responses
2. **Status codes are 200 or 201**
3. **App navigates correctly** based on role
4. **Backend logs** show incoming requests
5. **SMS notifications sent** (check backend console)
6. **No red error screens** in app

---

## 🎯 Demo Checklist

For your submission, demonstrate:

- [ ] Register Super Admin → Console shows API call
- [ ] Login → Console shows success
- [ ] Navigate to dashboard → Shows role-specific buttons
- [ ] Register Hospital → Console shows API call
- [ ] Login as Hospital → Register Patient
- [ ] Login as Patient → See emergency button
- [ ] Trigger emergency → Console shows API call
- [ ] Backend logs show SMS notifications

---

## 💡 Quick Commands

```bash
# Watch backend logs
cd your-backend-project
mvn spring-boot:run

# Watch Flutter console (already running)
# Look for "=== API CALL ===" messages

# Hot reload after code changes
# Press 'r' in Flutter console

# Restart app
# Press 'R' in Flutter console
```

---

**All API calls now have full debugging! Check your console for detailed logs.** 🚀
