# MamaAlert - API Integration Documentation

## 📡 Backend API Overview

This document describes how the Flutter app integrates with the MamaAlert Spring Boot backend.

## 🔗 Base URL Configuration

**File:** `lib/config/api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'http://YOUR_BACKEND_URL/api';
}
```

## 🔐 Authentication Flow

### 1. Login

**Endpoint:** `POST /auth/login`

**Request:**
```json
{
  "email": "patient@example.com",
  "password": "securePassword123"
}
```

**Success Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "role": "PATIENT",
  "userId": "507f1f77bcf86cd799439011"
}
```

**Error Response (401 Unauthorized):**
```json
{
  "message": "Invalid email or password",
  "timestamp": "2025-10-23T10:30:00"
}
```

**Implementation:** `lib/services/auth_service.dart`

```dart
static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Save token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', data['token']);
    return data;
  } else {
    throw Exception('Login failed');
  }
}
```

**Usage in App:**
```dart
// In login_screen.dart
await AuthService.login(
  email: emailController.text,
  password: passwordController.text,
);
```

---

## 🚨 Emergency Alert System

### 2. Trigger Emergency Alert

**Endpoint:** `POST /emergency-alerts`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request:**
```json
{
  "patientId": "507f1f77bcf86cd799439011",
  "latitude": 9.0820,
  "longitude": 8.6753
}
```

**Success Response (201 Created):**
```json
{
  "id": "alert_123456",
  "patientId": "507f1f77bcf86cd799439011",
  "status": "PENDING",
  "latitude": 9.0820,
  "longitude": 8.6753,
  "triggeredAt": "2025-10-23T10:30:00",
  "notifiedDrivers": [
    {
      "driverId": "driver_001",
      "distance": 2.5,
      "notificationSent": true
    },
    {
      "driverId": "driver_002",
      "distance": 5.8,
      "notificationSent": true
    }
  ],
  "notifiedContacts": [
    {
      "name": "John Doe",
      "phone": "+234XXXXXXXXXX",
      "relationship": "Husband",
      "notificationSent": true
    }
  ]
}
```

**Error Response (429 Too Many Requests):**
```json
{
  "message": "Please wait 10 minutes before triggering another alert",
  "remainingTime": 480,
  "lastAlertTime": "2025-10-23T10:20:00"
}
```

**Implementation:** `lib/services/emergency_service.dart`

```dart
static Future<Map<String, dynamic>> triggerEmergencyAlert({
  required String patientId,
  required double latitude,
  required double longitude,
}) async {
  final token = await _getAuthToken();
  
  final response = await http.post(
    Uri.parse('$baseUrl/emergency-alerts'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'patientId': patientId,
      'latitude': latitude,
      'longitude': longitude,
    }),
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else if (response.statusCode == 429) {
    throw Exception('Please wait 10 minutes before triggering another alert');
  } else {
    throw Exception('Failed to send emergency alert');
  }
}
```

**Usage in App:**
```dart
// In emergency_alert_screen.dart
try {
  await EmergencyService.triggerEmergencyAlert(
    patientId: user.id,
    latitude: currentLocation.latitude,
    longitude: currentLocation.longitude,
  );
  // Show success message
} catch (e) {
  // Show error (including cooldown message)
}
```

---

### 3. Get Emergency Alert History

**Endpoint:** `GET /emergency-alerts/history`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Success Response (200 OK):**
```json
[
  {
    "id": "alert_123456",
    "status": "RESOLVED",
    "latitude": 9.0820,
    "longitude": 8.6753,
    "triggeredAt": "2025-10-23T10:30:00",
    "respondedAt": "2025-10-23T10:35:00",
    "resolvedAt": "2025-10-23T11:00:00",
    "respondingDriver": {
      "id": "driver_001",
      "name": "Ibrahim Ahmed",
      "phone": "+234XXXXXXXXXX",
      "vehicleNumber": "ABC-123-XY"
    },
    "responseTime": "5 minutes",
    "resolutionTime": "30 minutes"
  },
  {
    "id": "alert_789012",
    "status": "PENDING",
    "latitude": 9.0850,
    "longitude": 8.6780,
    "triggeredAt": "2025-10-22T15:45:00",
    "notifiedDriversCount": 5
  }
]
```

**Implementation:**
```dart
static Future<List<Map<String, dynamic>>> getEmergencyHistory() async {
  final token = await _getAuthToken();
  
  final response = await http.get(
    Uri.parse('$baseUrl/emergency-alerts/history'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch emergency history');
  }
}
```

---

### 4. Get Alert Status

**Endpoint:** `GET /emergency-alerts/{alertId}`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Success Response (200 OK):**
```json
{
  "id": "alert_123456",
  "status": "IN_PROGRESS",
  "latitude": 9.0820,
  "longitude": 8.6753,
  "triggeredAt": "2025-10-23T10:30:00",
  "respondedAt": "2025-10-23T10:35:00",
  "respondingDriver": {
    "id": "driver_001",
    "name": "Ibrahim Ahmed",
    "phone": "+234XXXXXXXXXX",
    "currentLatitude": 9.0750,
    "currentLongitude": 8.6700,
    "estimatedArrival": "5 minutes"
  }
}
```

---

## 👤 Patient Management (Future Integration)

### 5. Get Patient Profile

**Endpoint:** `GET /patients/{patientId}`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Response:**
```json
{
  "id": "507f1f77bcf86cd799439011",
  "firstName": "Fatima",
  "lastName": "Ibrahim",
  "email": "fatima@example.com",
  "phone": "+234XXXXXXXXXX",
  "bloodGroup": "O+",
  "expectedDeliveryDate": "2025-12-15",
  "medicalHistory": "...",
  "emergencyContact": {
    "name": "John Doe",
    "phone": "+234XXXXXXXXXX",
    "relationship": "Husband"
  },
  "hospital": {
    "id": "hospital_001",
    "name": "General Hospital Lagos",
    "phone": "+234XXXXXXXXXX"
  }
}
```

---

### 6. Update Patient Profile

**Endpoint:** `PUT /patients/{patientId}`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request:**
```json
{
  "phone": "+234XXXXXXXXXX",
  "emergencyContact": {
    "name": "Updated Name",
    "phone": "+234YYYYYYYYYY",
    "relationship": "Brother"
  }
}
```

---

## 🔒 Security & Headers

### Required Headers

**All Authenticated Requests:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

### Token Management

**Token stored in:** `SharedPreferences`

**Get Token:**
```dart
final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('auth_token');
```

**Add Token to Request:**
```dart
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```

---

## ⚠️ Error Handling

### Common HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process response |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Show validation errors |
| 401 | Unauthorized | Redirect to login |
| 403 | Forbidden | Show access denied |
| 404 | Not Found | Show not found message |
| 429 | Too Many Requests | Show cooldown message |
| 500 | Server Error | Show try again later |

### Error Response Format

```json
{
  "message": "Error description",
  "timestamp": "2025-10-23T10:30:00",
  "status": 400,
  "error": "Bad Request"
}
```

### Handling in Flutter

```dart
try {
  final response = await http.post(...);
  
  if (response.statusCode == 200) {
    // Success
  } else {
    final error = json.decode(response.body);
    throw Exception(error['message']);
  }
} catch (e) {
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
```

---

## 📍 Location Data

### GPS Coordinates

**Format:** Decimal Degrees
- Latitude: -90 to +90
- Longitude: -180 to +180

**Example (Abuja, Nigeria):**
```dart
{
  "latitude": 9.0765,
  "longitude": 7.3986
}
```

### Getting Location in Flutter

```dart
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  
  if (!serviceEnabled) {
    throw Exception('Location services disabled');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  return await Geolocator.getCurrentPosition();
}
```

---

## 🧪 Testing APIs

### Using cURL

**Login:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"patient@example.com","password":"password123"}'
```

**Trigger Alert:**
```bash
curl -X POST http://localhost:8080/api/emergency-alerts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "patientId":"507f1f77bcf86cd799439011",
    "latitude":9.0820,
    "longitude":8.6753
  }'
```

### Using Postman

1. Create collection: "MamaAlert API"
2. Add environment variable: `baseUrl` = `http://localhost:8080/api`
3. Add environment variable: `token` = `{{login_token}}`
4. Test each endpoint

---

## 📊 API Rate Limits

| Endpoint | Limit | Window |
|----------|-------|--------|
| `/auth/login` | 5 requests | 15 minutes |
| `/emergency-alerts` | 1 request | 10 minutes |
| All others | 100 requests | 1 hour |

---

## 🔄 Backend Requirements

For the app to function correctly, ensure your backend:

1. ✅ Returns JWT token on successful login
2. ✅ Validates JWT on protected endpoints
3. ✅ Implements 10-minute cooldown for emergency alerts
4. ✅ Sends SMS to relatives and drivers
5. ✅ Calculates drivers within 10km radius
6. ✅ Returns proper error messages
7. ✅ Uses CORS headers for development

---

## 📝 Notes

- All timestamps are in ISO 8601 format
- Distances are in kilometers
- Phone numbers include country code
- JWT tokens expire after 24 hours
- Emergency cooldown is exactly 10 minutes

---

**API Version:** 1.0
**Last Updated:** October 23, 2025
