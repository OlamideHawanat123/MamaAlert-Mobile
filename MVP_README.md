# MamaAlert MVP - Role-Based Emergency Response System

## 🚨 Architecture

**Login → Role-Based Dashboard → Register/Emergency**

---

## ✅ What's in the MVP

### 1. **Login Screen**
- Email & Password
- Login → Redirects to appropriate dashboard based on role
- "Register as Super Admin" link (first-time setup)

### 2. **Role-Based Dashboards**

#### 🔷 **Super Admin Dashboard**
- Register Hospital button
- Register Driver Admin button

#### 🏥 **Hospital Dashboard**
- Register Patient button

#### 🏢 **Driver Admin Dashboard**
- Register Driver button

#### 💗 **Patient Dashboard**
- BIG RED EMERGENCY BUTTON

#### 🚗 **Driver Dashboard**
- View emergency alerts
- Availability status

---

## 🎯 Core Flow

```
App Opens → Login Screen
              |
     Enter Credentials
              |
         [Login]
              |
    Backend Returns Role
              |
    ┌─────────┴─────────┐
    ↓                   ↓
Super Admin       Hospital
Dashboard         Dashboard
├─ Register       └─ Register
│  Hospital          Patient
└─ Register
   Driver Admin
              |
    ┌─────────┴─────────┐
    ↓                   ↓
Driver Admin      Patient
Dashboard         Dashboard
└─ Register       └─ EMERGENCY
   Driver            BUTTON
```

---

## 🚀 How to Test (1 Hour Submission)

### **Step 1: Build Should Be Complete**
Your `flutter run` should be finishing up!

### **Step 2: First Time - Register Super Admin**
1. App opens → Login screen
2. Tap "Register as Super Admin"
3. Fill form:
   - First Name: John
   - Last Name: Doe
   - Email: admin@test.com
   - Phone: +234...
   - Password: test123
4. Tap "Register Super Admin"
5. Returns to login

### **Step 3: Login as Super Admin**
1. Email: admin@test.com
2. Password: test123
3. Tap "Login"
4. **→ Super Admin Dashboard appears**

### **Step 4: From Super Admin Dashboard**
You can:
- ✅ Register Hospital (creates hospital + hospital admin account)
- ✅ Register Driver Admin (creates driver admin account)

### **Step 5: Register Hospital**
1. Tap "Register Hospital"
2. Fill hospital details + admin account
3. Submit
4. **Logout** and login as that hospital admin

### **Step 6: From Hospital Dashboard**
- ✅ Register Patient (creates patient account)

### **Step 7: Login as Patient**
- **See BIG RED EMERGENCY BUTTON**
- Tap it → Trigger emergency → Backend sends SMS

---

## 📡 Backend APIs Used

| Feature | Endpoint | Method |
|---------|----------|--------|
| Login | `/auth/login` | POST |
| Register Super Admin | `/auth/register/super-admin` | POST |
| Register Patient | `/patients` | POST |
| **Emergency Alert** | `/emergency-alerts` | **POST** |

---

## 🎯 Core Flow

```
Login Screen
     ↓
Enter credentials
     ↓
[Login] → Backend validates
     ↓
Home Screen (Just emergency button)
     ↓
[EMERGENCY] → Backend sends alerts
     ↓
Success message
```

---

## ⚙️ Backend URL

Configured in: `lib/config/api_config.dart`

```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

- `10.0.2.2` = Emulator's localhost
- Change if backend is elsewhere

---

## 📱 What User Sees

1. **Login**: Simple form
2. **Register**: Select role → Fill form
3. **Home**: BIG red button saying "EMERGENCY"
4. **Alert**: Confirmation → Success/Error

**NO:**
- ❌ Pregnancy tracking
- ❌ Appointments
- ❌ Health records
- ❌ Due dates
- ❌ Charts
- ❌ Education content

**ONLY:**
- ✅ Login/Register
- ✅ Emergency button
- ✅ Backend integration

---

## 🎯 For Your Submission Demo

**Show this flow:**

1. ✅ **Login Screen** - Clean interface
2. ✅ **Register Super Admin** - First user setup
3. ✅ **Super Admin Dashboard** - Register hospital/driver admin buttons
4. ✅ **Hospital Dashboard** - Register patient button  
5. ✅ **Patient Dashboard** - BIG emergency button
6. ✅ **Emergency Alert** - Tap → Backend API called → SMS sent

**Perfect MVP demonstrating:**
- ✅ Role-based access control
- ✅ Hierarchical registration (Super Admin → Hospital → Patient)
- ✅ Emergency alert system
- ✅ Clean, intuitive UI
- ✅ Backend integration

---

**Current Status:** App is building, should be ready in 3-5 minutes!
