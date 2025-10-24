# MamaAlert Backend Integration - Complete ✅

## Overview
This Flutter app has been successfully updated to integrate with the MamaAlert Spring Boot backend located at `C:\Users\rahee\Desktop\MamaAlert`.

## Backend Configuration
- **Base URL**: `http://localhost:8080/api/v1`
- **Android Emulator URL**: `http://10.0.2.2:8080/api/v1`
- **Database**: MongoDB (localhost:27017/mamaalert)

## What Was Updated

### 1. API Configuration (`lib/config/api_config.dart`)
✅ Updated base URL to match backend: `/api/v1`
✅ Added all endpoint constants matching backend routes
✅ Configured for Android Emulator (10.0.2.2)

### 2. Models Created/Updated

#### Core Models:
- ✅ **UserModel** (`lib/models/user_model.dart`)
  - Matches backend `UserResponse` DTO
  - Added `Role` enum (SUPER_ADMIN, HOSPITAL, DRIVER_ADMIN, PATIENT, DRIVER)
  - Fields: id, firstName, lastName, email, phoneNumber, role, isActive, timestamps

- ✅ **LocationModel** (`lib/models/location_model.dart`)
  - Matches backend `Location` model
  - Fields: latitude, longitude, address

- ✅ **PatientModel** (`lib/models/patient_model.dart`)
  - Matches backend `PatientResponse` DTO
  - Fields: id, user, hospital, bloodGroup, expectedDeliveryDate, relative info, lastKnownLocation, medicalHistory

- ✅ **DriverModel** (`lib/models/driver_model.dart`)
  - Matches backend `DriverResponse` DTO
  - Fields: id, user, licenseNumber, vehicleType, vehicleNumber, currentLocation, isAvailable, isActive

- ✅ **HospitalModel** (`lib/models/hospital_model.dart`)
  - Matches backend `HospitalResponse` DTO
  - Fields: id, hospitalName, registrationNumber, location, adminUser, email, phoneNumber

- ✅ **EmergencyAlertModel** (`lib/models/emergency_alert_model.dart`)
  - Matches backend `EmergencyAlertResponse` DTO
  - Fields: id, patient, location, status, description, respondingDriver, notifiedDriverIds, timestamps

- ✅ **EmergencyStatus** (`lib/models/emergency_status.dart`)
  - Enum: PENDING, IN_PROGRESS, RESOLVED, CANCELLED

### 3. Services Updated

#### AuthService (`lib/services/auth_service.dart`)
✅ Updated all methods to handle backend `ApiResponse<T>` wrapper
✅ Fixed login to extract token and user from nested response
✅ Updated all registration methods to match backend DTOs
✅ Methods:
  - `login()` - Returns user with role
  - `registerSuperAdmin()`
  - `registerHospital()`
  - `registerDriverAdmin()`
  - `registerDriver()`
  - `registerPatient()`

#### EmergencyService (`lib/services/emergency_service.dart`)
✅ Updated to return typed models instead of Map
✅ Added support for ApiResponse wrapper
✅ Methods:
  - `triggerEmergencyAlert()` - Returns `EmergencyAlertModel`
  - `getEmergencyHistory()` - Returns `List<EmergencyAlertModel>`
  - `getAlertStatus()` - Returns `EmergencyAlertModel`

#### DriverService (`lib/services/driver_service.dart`) - NEW
✅ Created complete driver service
✅ Methods:
  - `updateDriverLocation()` - Update GPS location
  - `updateDriverAvailability()` - Toggle online/offline
  - `getDriverEmergencyAlerts()` - Get alerts for driver
  - `respondToEmergency()` - Driver accepts alert
  - `resolveEmergency()` - Mark emergency as resolved

#### PatientService (`lib/services/patient_service.dart`) - NEW
✅ Created patient service
✅ Methods:
  - `getPatientsByHospital()` - Hospital views their patients
  - `getPatientById()` - Get specific patient details

### 4. API Response Structure
All backend responses follow this structure:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

All services now properly unwrap this structure.

## Authentication Flow

### Login Response Structure:
```dart
{
  'token': 'JWT_TOKEN',
  'user': UserModel,
  'role': 'PATIENT',
  'userId': '123...'
}
```

### Stored in SharedPreferences:
- `auth_token` - JWT token for API calls
- `user_role` - User's role (PATIENT, DRIVER, etc.)
- `user_id` - User's ID
- `user_data` - Serialized UserModel

## User Roles & Permissions

### SUPER_ADMIN
- Register hospitals
- Register driver admins

### HOSPITAL
- Register patients
- View their patients

### DRIVER_ADMIN
- Register drivers

### PATIENT
- Trigger emergency alerts (10-min cooldown)

### DRIVER
- Update location & availability
- View emergency alerts
- Respond to emergencies
- Mark emergencies as resolved

## Emergency Alert Flow

1. **Patient** triggers alert via `EmergencyService.triggerEmergencyAlert()`
   ```dart
   final alert = await EmergencyService.triggerEmergencyAlert(
     patientId: patientId,
     latitude: 40.7128,
     longitude: -74.0060,
     address: '123 Main St',
     description: 'Emergency situation',
   );
   ```

2. **Backend** validates:
   - 10-minute cooldown check
   - Creates alert with status PENDING
   - Sends SMS to patient's relative
   - Finds drivers within 10km radius
   - Sends SMS to all nearby drivers

3. **Driver** views alerts via `DriverService.getDriverEmergencyAlerts()`
   ```dart
   final alerts = await DriverService.getDriverEmergencyAlerts(
     driverId: driverId,
   );
   ```

4. **Driver** responds via `DriverService.respondToEmergency()`
   ```dart
   final alert = await DriverService.respondToEmergency(
     alertId: alertId,
     driverId: driverId,
   );
   // Status changes to IN_PROGRESS
   // Driver availability becomes false
   ```

5. **Driver** resolves via `DriverService.resolveEmergency()`
   ```dart
   final alert = await DriverService.resolveEmergency(
     alertId: alertId,
     driverId: driverId,
     resolutionNotes: 'Patient transported to hospital',
   );
   // Status changes to RESOLVED
   // Driver availability becomes true
   ```

## Testing Checklist

### Backend Setup
- [ ] MongoDB is running (`mongod`)
- [ ] Backend is running (`mvn spring-boot:run`)
- [ ] Backend accessible at `http://localhost:8080`
- [ ] Test endpoint: `http://localhost:8080/api/v1/auth/login`

### Flutter App Setup
- [ ] Dependencies installed (`flutter pub get`)
- [ ] API config points to correct URL
- [ ] Android Emulator running (or iOS Simulator)

### Test Sequence

1. **Register Super Admin**
   ```dart
   await AuthService.registerSuperAdmin(
     firstName: 'Admin',
     lastName: 'User',
     email: 'admin@mamaalert.com',
     phoneNumber: '1234567890',
     password: 'admin123',
   );
   ```

2. **Login as Super Admin**
   ```dart
   final result = await AuthService.login(
     email: 'admin@mamaalert.com',
     password: 'admin123',
   );
   // Should return role: SUPER_ADMIN
   ```

3. **Register Hospital**
   ```dart
   await AuthService.registerHospital(
     hospitalName: 'City Hospital',
     registrationNumber: 'HOSP001',
     latitude: 40.7128,
     longitude: -74.0060,
     address: '123 Hospital St',
     email: 'hospital@city.com',
     phoneNumber: '9876543210',
     adminFirstName: 'Hospital',
     adminLastName: 'Admin',
     adminEmail: 'hospitaladmin@city.com',
     adminPhoneNumber: '5555555555',
     adminPassword: 'hospital123',
   );
   ```

4. **Login as Hospital & Register Patient**
   ```dart
   await AuthService.login(
     email: 'hospitaladmin@city.com',
     password: 'hospital123',
   );
   
   await AuthService.registerPatient(
     firstName: 'Jane',
     lastName: 'Doe',
     email: 'jane@example.com',
     phoneNumber: '1111111111',
     password: 'patient123',
     bloodGroup: 'O+',
     expectedDeliveryDate: '2025-12-31',
     medicalHistory: 'No complications',
     relativeName: 'John Doe',
     relativePhoneNumber: '2222222222',
     relativeRelationship: 'Husband',
     hospitalId: '<hospital_id_from_step_3>',
   );
   ```

5. **Register Driver Admin**
   ```dart
   await AuthService.registerDriverAdmin(
     organizationName: 'Quick Response',
     firstName: 'Driver',
     lastName: 'Admin',
     email: 'driveradmin@qr.com',
     phoneNumber: '3333333333',
     password: 'driveradmin123',
   );
   ```

6. **Login as Driver Admin & Register Driver**
   ```dart
   await AuthService.login(
     email: 'driveradmin@qr.com',
     password: 'driveradmin123',
   );
   
   await AuthService.registerDriver(
     firstName: 'John',
     lastName: 'Driver',
     email: 'driver@qr.com',
     phoneNumber: '4444444444',
     password: 'driver123',
     licenseNumber: 'DL123456',
     vehicleType: 'Ambulance',
     vehicleNumber: 'AMB-001',
     driverAdminId: '<driver_admin_id>',
   );
   ```

7. **Login as Patient & Trigger Emergency**
   ```dart
   await AuthService.login(
     email: 'jane@example.com',
     password: 'patient123',
   );
   
   final alert = await EmergencyService.triggerEmergencyAlert(
     patientId: '<patient_id>',
     latitude: 40.7128,
     longitude: -74.0060,
     description: 'Need urgent help',
   );
   // Should receive success response
   ```

8. **Login as Driver & Handle Emergency**
   ```dart
   await AuthService.login(
     email: 'driver@qr.com',
     password: 'driver123',
   );
   
   // Update location
   await DriverService.updateDriverLocation(
     driverId: '<driver_id>',
     latitude: 40.7128,
     longitude: -74.0060,
   );
   
   // Toggle availability
   await DriverService.updateDriverAvailability(
     driverId: '<driver_id>',
     isAvailable: true,
   );
   
   // View alerts
   final alerts = await DriverService.getDriverEmergencyAlerts(
     driverId: '<driver_id>',
   );
   
   // Respond to alert
   await DriverService.respondToEmergency(
     alertId: '<alert_id>',
     driverId: '<driver_id>',
   );
   
   // Resolve emergency
   await DriverService.resolveEmergency(
     alertId: '<alert_id>',
     driverId: '<driver_id>',
     resolutionNotes: 'Patient safely transported',
   );
   ```

## Common Issues & Solutions

### 1. Connection Refused
**Problem**: Can't connect to backend
**Solution**: 
- Verify backend is running on port 8080
- Use `10.0.2.2` for Android Emulator
- Use `localhost` for iOS Simulator
- Use actual IP address for physical devices

### 2. 401 Unauthorized
**Problem**: API returns 401
**Solution**: 
- Check if token is saved after login
- Verify token is included in Authorization header
- Token might be expired (24 hours)

### 3. 403 Forbidden
**Problem**: API returns 403
**Solution**: 
- Check user role matches required permission
- Verify @PreAuthorize annotation in backend

### 4. 429 Too Many Requests
**Problem**: Emergency alert rejected
**Solution**: 
- Wait 10 minutes between emergency alerts
- Check patient's last alert time

### 5. Model Parsing Errors
**Problem**: JSON parsing fails
**Solution**: 
- Check backend response structure matches models
- Enable debug logging to see raw response
- Verify all required fields are present

## Debug Mode
All services include debug logging. Enable in Flutter:
```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug info here');
}
```

## Next Steps

### For UI Integration:
1. Update screen widgets to use new models
2. Handle loading states during API calls
3. Display error messages to users
4. Add refresh functionality
5. Implement real-time location tracking for drivers
6. Add push notifications for emergency alerts

### For Production:
1. Change API URL to production server
2. Enable HTTPS/SSL
3. Add error tracking (Sentry, Firebase Crashlytics)
4. Implement token refresh mechanism
5. Add offline support with local caching
6. Set up CI/CD pipeline

## File Structure
```
lib/
├── config/
│   └── api_config.dart (Updated ✅)
├── models/
│   ├── user_model.dart (Updated ✅)
│   ├── location_model.dart (New ✅)
│   ├── patient_model.dart (New ✅)
│   ├── driver_model.dart (New ✅)
│   ├── hospital_model.dart (New ✅)
│   ├── emergency_alert_model.dart (New ✅)
│   ├── emergency_status.dart (New ✅)
│   ├── appointment_model.dart (Keep for future use)
│   ├── health_record_model.dart (Keep for future use)
│   └── education_content_model.dart (Keep for future use)
├── services/
│   ├── auth_service.dart (Updated ✅)
│   ├── emergency_service.dart (Updated ✅)
│   ├── driver_service.dart (New ✅)
│   ├── patient_service.dart (New ✅)
│   ├── notification_service.dart (Keep for future use)
│   └── education_service.dart (Keep for future use)
└── ...
```

## Backend API Documentation

### Auth Endpoints
- `POST /auth/register/super-admin` - Register first super admin (public)
- `POST /auth/login` - Login (public)

### Hospital Endpoints (SUPER_ADMIN)
- `POST /hospitals` - Register hospital

### Driver Admin Endpoints (SUPER_ADMIN)
- `POST /driver-admins` - Register driver admin

### Patient Endpoints (HOSPITAL)
- `POST /patients` - Register patient
- `GET /patients/hospital/{hospitalId}` - Get patients by hospital

### Driver Endpoints
- `POST /drivers` - Register driver (DRIVER_ADMIN)
- `PUT /drivers/{id}/location` - Update location (DRIVER)
- `PUT /drivers/{id}/availability` - Update availability (DRIVER)

### Emergency Endpoints
- `POST /emergency-alerts` - Trigger alert (PATIENT)
- `GET /emergency-alerts/driver/{driverId}` - Get driver alerts (DRIVER)
- `POST /emergency-alerts/{alertId}/respond` - Respond to alert (DRIVER)
- `POST /emergency-alerts/resolve` - Resolve alert (DRIVER)

## Support
For issues or questions, check:
1. Backend logs in terminal running `mvn spring-boot:run`
2. Flutter app logs with `flutter run`
3. MongoDB logs
4. Network traffic in browser DevTools or Postman

---
**Integration Status**: ✅ COMPLETE
**Last Updated**: 2025-10-23
**Backend Version**: MamaAlert v0.0.1-SNAPSHOT
**Flutter SDK**: ^3.9.2
