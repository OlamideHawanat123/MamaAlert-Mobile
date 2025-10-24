# MamaAlert - Registration Feature Guide

## 📝 Overview

The app now includes **complete registration functionality** for all user roles that integrates with your Spring Boot backend APIs.

---

## 🎯 User Roles & Registration

### 1. **Super Admin** (Public Access)
**Endpoint:** `POST /auth/register/super-admin`

**Access:** Public (First-time system setup)

**Fields:**
- First Name
- Last Name
- Email
- Phone
- Password

**Can Register:**
- ✅ Hospitals
- ✅ Driver Admins

**Screen:** `RegisterSuperAdminScreen`

---

### 2. **Hospital** (Super Admin Only)
**Endpoint:** `POST /hospitals`

**Access:** Requires Super Admin authentication

**Fields:**
- Hospital name
- Registration number
- Address
- Latitude/Longitude
- Email & Phone
- Admin account details

**Can Register:**
- ✅ Patients

**Screen:** `RegisterHospitalScreen`

---

### 3. **Driver Admin** (Super Admin Only)
**Endpoint:** `POST /driver-admins`

**Access:** Requires Super Admin authentication

**Fields:**
- Organization name
- First Name, Last Name
- Email, Phone
- Password

**Can Register:**
- ✅ Drivers

**Screen:** `RegisterDriverAdminScreen`

---

### 4. **Driver** (Driver Admin Only)
**Endpoint:** `POST /drivers`

**Access:** Requires Driver Admin authentication

**Fields:**
- Personal info (name, email, phone, password)
- License number
- Vehicle type & number
- Current location (lat/long)
- Driver Admin ID

**Screen:** `RegisterDriverScreen`

---

### 5. **Patient** (Hospital Only)
**Endpoint:** `POST /patients`

**Access:** Requires Hospital authentication

**Fields:**
- Personal info (name, email, phone, password)
- Blood group
- Expected delivery date
- Medical history
- Emergency contact (name, phone, relationship)
- Hospital ID

**Screen:** `RegisterPatientScreen`

---

## 🚀 How to Use

### From Login Screen

1. Launch the app
2. On the **Login Screen**, tap **"Register"** button
3. Select your role from the **Registration Selection Screen**
4. Fill out the registration form
5. Tap **"Register [Role]"** button
6. API call is made to your backend
7. On success, you're redirected to login

---

## 📡 API Integration Details

### Request Headers

**Public Registration (Super Admin):**
```http
POST http://10.0.2.2:8080/api/auth/register/super-admin
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "admin@example.com",
  "phone": "+234XXXXXXXXXX",
  "password": "password123"
}
```

**Authenticated Registration (Hospital, Driver Admin, Driver, Patient):**
```http
POST http://10.0.2.2:8080/api/hospitals
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "name": "General Hospital",
  "registrationNumber": "REG001",
  ...
}
```

---

## 🔐 Authentication Flow

### For Authenticated Registrations

1. User must be **logged in** first
2. JWT token is retrieved from SharedPreferences
3. Token is added to `Authorization` header
4. Backend validates token and role permissions
5. Registration succeeds or fails with error message

### Token Storage

```dart
// Stored in SharedPreferences during login
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', 'eyJhbGc...');
await prefs.setString('user_role', 'SUPER_ADMIN');
```

---

## 🎨 UI Features

### Registration Selection Screen

Displays all roles with:
- ✅ **Color-coded cards** (Purple, Pink, Blue, Orange, Green)
- ✅ **Role icons**
- ✅ **Access level badges** ("Public Access", "Super Admin Access", etc.)
- ✅ **Descriptions**

### Registration Forms

- ✅ **Input validation**
- ✅ **Password visibility toggle**
- ✅ **Loading states**
- ✅ **Error handling**
- ✅ **Success messages**
- ✅ **Form sections** (Personal Info, Medical Info, Emergency Contact)

---

## 📋 Form Validation

### Common Validations

| Field | Validation |
|-------|-----------|
| Name | Required, not empty |
| Email | Required, contains `@` |
| Phone | Required, not empty |
| Password | Required, minimum 6 characters |
| Latitude | Required, valid number |
| Longitude | Required, valid number |
| Blood Group | Dropdown selection |
| Delivery Date | Date picker |

---

## ✅ Testing Registration

### Test Super Admin Registration

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **On Login Screen:**
   - Tap "Register"
   - Select "Super Admin"
   - Fill form:
     - First Name: John
     - Last Name: Doe
     - Email: admin@test.com
     - Phone: +234XXXXXXXXXX
     - Password: password123
   - Tap "Register Super Admin"

3. **Backend Logs:**
   ```
   POST /api/auth/register/super-admin
   Status: 201 Created
   Response: { "id": "...", "email": "admin@test.com", ... }
   ```

4. **Success:**
   - Green snackbar: "Super Admin registered successfully!"
   - Redirected to Login screen
   - Can now login with credentials

---

### Test Patient Registration

1. **Login as Hospital admin first**
2. **Navigate to Registration**
3. **Select "Patient"**
4. **Fill comprehensive form:**
   - Personal info
   - Medical info (blood group, delivery date)
   - Emergency contact
   - Hospital ID

5. **Backend receives:**
   ```json
   {
     "firstName": "Fatima",
     "lastName": "Ibrahim",
     "bloodGroup": "O+",
     "expectedDeliveryDate": "2025-12-15",
     "emergencyContact": {
       "name": "Ahmad Ibrahim",
       "phone": "+234...",
       "relationship": "Husband"
     },
     "hospitalId": "hospital_001"
   }
   ```

---

## 🔄 Registration Flow Diagram

```
Login Screen
     |
     | Tap "Register"
     ↓
Registration Selection Screen
     |
     | Select Role
     ↓
Role-Specific Registration Form
     |
     | Fill & Submit
     ↓
API Call to Backend
     |
     ├─→ Success → Show Success Message → Navigate to Login
     └─→ Failure → Show Error Message → Stay on Form
```

---

## 🛠️ Files Created

### Services
- ✅ `lib/services/auth_service.dart` (Updated with 5 registration methods)

### Screens
- ✅ `lib/screens/registration_selection_screen.dart`
- ✅ `lib/screens/register_super_admin_screen.dart`
- ✅ `lib/screens/register_hospital_screen.dart`
- ✅ `lib/screens/register_driver_admin_screen.dart`
- ✅ `lib/screens/register_driver_screen.dart`
- ✅ `lib/screens/register_patient_screen.dart`
- ✅ `lib/screens/login_screen.dart` (Updated with Register button)

---

## 🐛 Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "Connection refused" | Backend not running | Start backend server |
| "Unauthorized" | Invalid/missing token | Login first with correct role |
| "Registration failed" | Validation error | Check required fields |
| "Email already exists" | Duplicate email | Use different email |

### Error Display

```dart
try {
  await AuthService.registerPatient(...);
  // Success message
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Failed: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 📊 Backend Requirements

Ensure your backend:

1. ✅ Accepts JSON content-type
2. ✅ Validates JWT tokens for protected endpoints
3. ✅ Returns proper status codes:
   - `201 Created` - Success
   - `400 Bad Request` - Validation error
   - `401 Unauthorized` - Auth required
   - `409 Conflict` - Duplicate entry
4. ✅ Returns error messages in JSON:
   ```json
   {
     "message": "Email already exists"
   }
   ```

---

## 🎯 Next Steps

1. **Test each registration role:**
   - Super Admin (public)
   - Patient (hospital auth)
   - Driver (driver admin auth)
   - Hospital (super admin auth)
   - Driver Admin (super admin auth)

2. **Verify backend logs:**
   - Check POST requests
   - Verify SMS notifications (for patients)
   - Confirm database entries

3. **Test edge cases:**
   - Invalid emails
   - Duplicate registrations
   - Missing required fields
   - Wrong token/role

---

## 💡 Tips

- **Super Admin first:** Register a Super Admin first (public access)
- **Login required:** Most registrations require prior authentication
- **Role hierarchy:** Super Admin → Hospital/Driver Admin → Patient/Driver
- **Test data:** Use fake data for testing (don't use real personal info)
- **Backend logs:** Monitor backend console for API calls

---

**All registration features are now fully integrated with your backend! 🎉**

Test the registration flow and let me know if you encounter any issues.
