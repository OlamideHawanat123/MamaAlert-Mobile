# Mama Alert - Simplified App Architecture

## App Purpose
**Emergency Patient-Driver Connection System**

Connect pregnant patients experiencing emergencies with nearby available drivers for immediate transportation to hospitals.

---

## Core Components

### 1. User Roles
- **Super Admin** - System administrator who creates hospitals and driver admins
- **Hospital** - Medical facilities that register patients
- **Driver Admin** - Organization that manages drivers
- **Patient** - Pregnant women who can trigger emergency alerts
- **Driver** - Drivers who respond to emergency alerts

### 2. Key Features

#### Authentication
- Login system for all user types
- Role-based registration flow
- JWT token-based authentication
- Secure local storage of credentials

#### Emergency Alert System
- **Patient Side:**
  - Trigger emergency alert with one button
  - Share current GPS location
  - Alert nearby drivers automatically
  
- **Driver Side:**
  - Receive real-time emergency notifications
  - View patient location on map
  - Accept/decline emergency requests
  - Navigate to patient location

#### Location Services
- Real-time GPS tracking
- Geocoding (address lookup)
- Calculate distance between patient and drivers
- Find drivers within configurable radius (default: 10km)

#### Notifications
- Emergency push notifications to drivers
- Alert sound and vibration
- Show patient name and location

---

## Technical Stack

### Frontend (Flutter)
- **Language:** Dart
- **Platforms:** Android, iOS, Web, Windows, macOS, Linux
- **State Management:** Provider
- **HTTP Client:** http package
- **Location:** geolocator, geocoding
- **Notifications:** flutter_local_notifications
- **Storage:** shared_preferences

### Backend Integration
- **Base URL:** `http://10.0.2.2:8080/api/v1` (Android Emulator)
- **Authentication:** JWT tokens
- **API Format:** RESTful JSON

---

## API Endpoints Used

### Authentication
- `POST /auth/login` - User login
- `POST /auth/register/super-admin` - Initial super admin registration

### Emergency Alerts
- `POST /emergency-alerts` - Create new emergency alert
- `GET /emergency-alerts` - List emergency alerts
- `GET /emergency-alerts/{id}` - Get alert details
- `PUT /emergency-alerts/{id}/status` - Update alert status

### User Management
- `POST /patients` - Register new patient
- `GET /patients` - List patients
- `POST /drivers` - Register new driver
- `GET /drivers` - List drivers
- `POST /hospitals` - Register new hospital
- `GET /hospitals` - List hospitals
- `POST /driver-admins` - Register driver admin
- `GET /driver-admins` - List driver admins

---

## App Flow

### Initial Setup
1. Super Admin registers via special registration screen
2. Super Admin logs in
3. Super Admin creates Hospital accounts
4. Super Admin creates Driver Admin accounts

### Ongoing Operations
5. Hospital registers Patients
6. Driver Admin registers Drivers
7. All users can log in to their respective dashboards

### Emergency Scenario
8. Patient clicks "Emergency Alert" button
9. App gets patient's GPS location
10. Backend finds nearby drivers (within 10km radius)
11. Notifications sent to available drivers
12. Driver accepts the alert
13. Driver navigates to patient location
14. Driver transports patient to hospital

---

## File Structure

```
lib/
├── config/
│   └── api_config.dart                 # Backend configuration
├── models/
│   ├── user_model.dart                # Base user model
│   ├── patient_model.dart             # Patient data
│   ├── driver_model.dart              # Driver data
│   ├── hospital_model.dart            # Hospital data
│   ├── emergency_alert_model.dart     # Emergency alert data
│   ├── emergency_status.dart          # Alert status enum
│   └── location_model.dart            # GPS location data
├── services/
│   ├── auth_service.dart              # Authentication logic
│   ├── emergency_service.dart         # Emergency alert handling
│   ├── notification_service.dart      # Push notifications
│   ├── patient_service.dart           # Patient operations
│   └── driver_service.dart            # Driver operations
├── providers/
│   └── user_provider.dart             # User state management
├── screens/
│   ├── dashboards/
│   │   ├── super_admin_dashboard.dart
│   │   ├── hospital_dashboard.dart
│   │   ├── driver_admin_dashboard.dart
│   │   ├── patient_dashboard.dart
│   │   └── driver_dashboard.dart
│   ├── login_screen.dart
│   ├── register_super_admin_screen.dart
│   ├── register_hospital_screen.dart
│   ├── register_driver_admin_screen.dart
│   ├── register_patient_screen.dart
│   ├── register_driver_screen.dart
│   ├── emergency_alert_screen.dart
│   ├── profile_screen.dart
│   └── home_screen.dart
├── widgets/
│   └── quick_action_button.dart       # Reusable button
└── main.dart                           # App entry point
```

---

## Configuration

### Backend URL
Located in `lib/config/api_config.dart`:
- **Android Emulator:** `http://10.0.2.2:8080/api/v1`
- **For physical device:** Update to your local network IP

### Emergency Settings
- **Radius:** 10km (drivers within this distance receive alerts)
- **Cooldown:** 10 minutes (prevent duplicate alerts)
- **Timeout:** 30 seconds (API request timeout)

---

## Permissions Required

### Android
- **Location:** `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- **Notifications:** `POST_NOTIFICATIONS` (Android 13+)
- **Internet:** `INTERNET`

### iOS
- **Location:** When in use
- **Notifications:** Alert, sound, badge

---

## Build Requirements

### Dependencies
```yaml
provider: ^6.1.1                        # State management
shared_preferences: ^2.2.2              # Local storage
intl: ^0.19.0                          # Date formatting
flutter_local_notifications: ^17.0.0    # Notifications
permission_handler: ^11.2.0             # Permissions
http: ^1.2.0                           # API calls
geolocator: ^11.0.0                    # GPS
geocoding: ^3.0.0                      # Address lookup
```

### Android Configuration
- Min SDK: 21
- Target SDK: 35
- Core library desugaring enabled
- Location and notification permissions in manifest

---

## Testing Checklist

- [ ] Super Admin registration
- [ ] Super Admin login
- [ ] Hospital registration by Super Admin
- [ ] Driver Admin registration by Super Admin
- [ ] Patient registration by Hospital
- [ ] Driver registration by Driver Admin
- [ ] Patient emergency alert creation
- [ ] Driver receives notification
- [ ] Driver accepts alert
- [ ] Location tracking works
- [ ] Profile viewing/editing

---

## Future Enhancements (Not Implemented)
- Real-time driver location tracking
- In-app messaging between patient and driver
- Rating system for drivers
- Emergency alert history
- Multiple language support
- Offline mode support
- Video call capability
