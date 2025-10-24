# MamaAlert App Flow Guide

## 📱 Complete Navigation Flow

### 1️⃣ Login Screen (Default Starting Point)

**What you see:**
- Email and password fields
- **"Login"** button
- **"Register as Super Admin"** button (for first-time setup)
- Info text: "Other users will be registered by their respective admins"

**Actions:**
- Login → Goes to appropriate dashboard based on role
- Register as Super Admin → Goes to Super Admin Registration

---

### 2️⃣ Super Admin Dashboard

**What you see:**
- Title: "Super Administrator"
- Icon: Admin panel settings
- Two main action cards:
  1. **"Register Hospital"** button (Blue card)
  2. **"Register Driver Admin"** button (Orange card)

**Flow:**
- Super Admin registers Hospitals
- Super Admin registers Driver Admins
- These are the ONLY registrations Super Admin performs

---

### 3️⃣ Hospital Dashboard

**What you see:**
- Title: "Hospital Portal"
- Icon: Hospital
- One main action card:
  1. **"Register Patient"** button (Pink card)

**Flow:**
- Hospital staff registers Patients
- Patients are pregnant women who may need emergency help

---

### 4️⃣ Driver Admin Dashboard

**What you see:**
- Title: "Driver Admin Portal"
- Icon: Business/Building
- One main action card:
  1. **"Register Driver"** button (Green card)

**Flow:**
- Driver Admin registers Drivers
- Drivers are the ones who respond to emergency alerts

---

### 5️⃣ Patient Dashboard

**What you see:**
- Title: "MamaAlert - Patient"
- Icon: Emergency
- **HUGE RED EMERGENCY BUTTON** (200px tall)
  - Text: "EMERGENCY - Tap for Help"

**Flow:**
- Patient clicks the big red button when in emergency
- System sends alert to nearby drivers
- Driver responds and provides transport

---

### 6️⃣ Driver Dashboard

**What you see:**
- Title: "Driver Portal"
- Icon: Taxi
- Status indicator: "You are available"
- **"View Emergency Alerts"** button

**Flow:**
- Driver receives push notifications for nearby emergencies
- Driver can view all emergency alerts
- Driver accepts and responds to emergencies

---

## 📊 Registration Hierarchy

```
┌─────────────────────┐
│   Super Admin       │ ← Registers first (from Login screen)
│  (System Setup)     │
└──────────┬──────────┘
           │
           ├──────────────────┬──────────────────┐
           │                  │                  │
           ▼                  ▼                  │
    ┌──────────┐      ┌──────────────┐          │
    │ Hospital │      │ Driver Admin │          │
    └────┬─────┘      └──────┬───────┘          │
         │                   │                  │
         │                   │                  │
         ▼                   ▼                  │
    ┌─────────┐         ┌─────────┐            │
    │ Patient │         │ Driver  │            │
    └─────────┘         └─────────┘            │
         │                   │                  │
         │                   │                  │
         └────────┬──────────┘                  │
                  │                             │
                  ▼                             │
         ┌─────────────────┐                    │
         │ Emergency Alert │                    │
         └─────────────────┘                    │
                                                │
         All users can login ←──────────────────┘
```

---

## 🚨 Emergency Alert Flow

```
┌──────────┐
│ Patient  │
│ (in need)│
└────┬─────┘
     │
     │ 1. Clicks BIG RED BUTTON
     ▼
┌──────────────────┐
│ Emergency Alert  │
│   is created     │
└────┬─────────────┘
     │
     │ 2. Backend finds nearby drivers (within 10km)
     ▼
┌──────────────────┐
│ Push Notification│ ──► 📱 Driver 1
│  to all nearby   │ ──► 📱 Driver 2
│     drivers      │ ──► 📱 Driver 3
└────┬─────────────┘
     │
     │ 3. First driver accepts
     ▼
┌──────────────────┐
│ Driver navigates │
│  to patient      │
└────┬─────────────┘
     │
     │ 4. Driver picks up patient
     ▼
┌──────────────────┐
│ Transport to     │
│    hospital      │
└──────────────────┘
```

---

## 🎨 Dashboard Colors

| Role           | Color  | Purpose                        |
|----------------|--------|--------------------------------|
| Super Admin    | Purple | System administration          |
| Hospital       | Blue   | Register patients              |
| Driver Admin   | Orange | Register drivers               |
| Patient        | **Red**    | **Emergency alerts**           |
| Driver         | Green  | Respond to emergencies         |

---

## 🔑 Key Features per Dashboard

### Super Admin
- ✅ Register Hospital
- ✅ Register Driver Admin
- ✅ Logout

### Hospital
- ✅ Register Patient
- ✅ Logout

### Driver Admin
- ✅ Register Driver
- ✅ Logout

### Patient
- ✅ **BIG RED EMERGENCY BUTTON**
- ✅ Logout

### Driver
- ✅ View Emergency Alerts
- ✅ Receive Push Notifications
- ✅ Availability Status
- ✅ Logout

---

## 📲 Login Screen Details

The login screen serves as:
1. **Main entry point** for all existing users
2. **Registration gateway** for Super Admin (first-time setup)
3. **Information center** explaining the registration hierarchy

**Important Note:**
- Only Super Admin can self-register
- All other users (Hospital, Driver Admin, Patient, Driver) must be registered by their respective admins
- This ensures proper organizational hierarchy and accountability

---

## 🎯 User Journey Examples

### Example 1: Initial System Setup
1. First person → Opens app → Clicks "Register as Super Admin"
2. Super Admin → Logs in → Registers Hospital A
3. Super Admin → Registers Driver Admin B
4. Done! System ready for operations.

### Example 2: Adding a Patient
1. Hospital A → Logs in → Clicks "Register Patient"
2. Fills patient details → Patient account created
3. Patient → Logs in → Sees BIG RED EMERGENCY BUTTON
4. Ready to use!

### Example 3: Adding a Driver
1. Driver Admin B → Logs in → Clicks "Register Driver"
2. Fills driver details → Driver account created
3. Driver → Logs in → Sees "View Emergency Alerts"
4. Starts receiving notifications!

### Example 4: Emergency Response
1. Patient → Clicks BIG RED BUTTON
2. Nearby drivers → Receive notification
3. Driver → Accepts alert
4. Driver → Picks up patient → Transports to hospital
5. Emergency resolved! ✅

---

## 💡 Design Principles

1. **Simplicity**: Each dashboard has ONE primary action
2. **Clarity**: Color-coded roles for easy identification
3. **Urgency**: Patient emergency button is LARGE and RED
4. **Hierarchy**: Clear registration flow from top to bottom
5. **Safety**: Logout always available
6. **Efficiency**: Minimal clicks to perform core actions

---

## 🔒 Security Notes

- All API calls use JWT authentication
- Tokens stored securely in SharedPreferences
- Role-based access control enforced by backend
- Each role can only perform their designated actions

---

**The app layout is now complete and matches your exact requirements!** 🎉
