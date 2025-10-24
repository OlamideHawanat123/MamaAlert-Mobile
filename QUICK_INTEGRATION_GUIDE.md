# 🚀 Quick Integration Guide - MamaAlert Flutter App

## ✅ Integration Complete!

Your Flutter app is now fully integrated with the MamaAlert Spring Boot backend.

## 📁 Files Updated/Created

### Configuration
- ✅ `lib/config/api_config.dart` - Updated with correct backend URL

### Models (NEW)
- ✅ `lib/models/user_model.dart` - Updated with Role enum
- ✅ `lib/models/location_model.dart` - NEW
- ✅ `lib/models/patient_model.dart` - NEW
- ✅ `lib/models/driver_model.dart` - NEW
- ✅ `lib/models/hospital_model.dart` - NEW
- ✅ `lib/models/emergency_alert_model.dart` - NEW
- ✅ `lib/models/emergency_status.dart` - NEW

### Services
- ✅ `lib/services/auth_service.dart` - Updated for backend API
- ✅ `lib/services/emergency_service.dart` - Updated for typed responses
- ✅ `lib/services/driver_service.dart` - NEW (complete driver operations)
- ✅ `lib/services/patient_service.dart` - NEW (patient operations)

### Providers
- ✅ `lib/providers/user_provider.dart` - Updated for new UserModel

### Documentation
- ✅ `BACKEND_INTEGRATION.md` - Complete integration documentation
- ✅ `lib/examples/service_usage_examples.dart` - Code examples

## 🎯 Quick Start

### 1. Start Backend
```bash
# Terminal 1: Start MongoDB
mongod

# Terminal 2: Start Spring Boot backend
cd C:\Users\rahee\Desktop\MamaAlert
mvn spring-boot:run
```

Backend will run on: `http://localhost:8080/api/v1`

### 2. Run Flutter App
```bash
cd C:\Users\rahee\Desktop\mama_alert_app
flutter pub get
flutter run
```

## 🔑 Test Sequence (5 minutes)

### Step 1: Register Super Admin
```dart
await AuthService.registerSuperAdmin(
  firstName: 'Admin',
  lastName: 'User',
  email: 'admin@mamaalert.com',
  phoneNumber: '1234567890',
  password: 'admin123',
);
```

### Step 2: Login
```dart
final result = await AuthService.login(
  email: 'admin@mamaalert.com',
  password: 'admin123',
);
final user = result['user'] as UserModel;
print('Role: ${user.role.name}'); // SUPER_ADMIN
```

### Step 3: Register Hospital
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

### Step 4: Register Patient (as Hospital)
```dart
// Login as hospital first
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
  hospitalId: 'hospitalId', // Get from step 3
);
```

### Step 5: Trigger Emergency (as Patient)
```dart
// Login as patient
await AuthService.login(
  email: 'jane@example.com',
  password: 'patient123',
);

final alert = await EmergencyService.triggerEmergencyAlert(
  patientId: 'patientId', // Get from step 4
  latitude: 40.7128,
  longitude: -74.0060,
  description: 'Need help!',
);

print('Emergency triggered: ${alert.id}');
```

## 🎨 UI Integration Examples

### Login Screen
```dart
final result = await AuthService.login(
  email: emailController.text,
  password: passwordController.text,
);

final user = result['user'] as UserModel;

// Navigate based on role
switch (user.role) {
  case Role.PATIENT:
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (_) => PatientDashboard()));
    break;
  case Role.DRIVER:
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (_) => DriverDashboard()));
    break;
  // ... other roles
}
```

### Emergency Button (Patient)
```dart
ElevatedButton(
  onPressed: () async {
    try {
      final position = await Geolocator.getCurrentPosition();
      
      final alert = await EmergencyService.triggerEmergencyAlert(
        patientId: userId,
        latitude: position.latitude,
        longitude: position.longitude,
        description: 'Emergency!',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emergency alert sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  },
  child: Text('EMERGENCY'),
)
```

### Driver Alert List
```dart
FutureBuilder<List<EmergencyAlertModel>>(
  future: DriverService.getDriverEmergencyAlerts(
    driverId: driverId,
  ),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final alert = snapshot.data![index];
          return ListTile(
            title: Text(alert.patient?.user.fullName ?? 'Unknown'),
            subtitle: Text(alert.status.name),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () => respondToAlert(alert.id),
            ),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

## 🔍 Troubleshooting

### "Connection refused" error
**Solution**: Use `10.0.2.2` for Android Emulator (already configured)
```dart
// In api_config.dart
static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
```

### "401 Unauthorized" error
**Solution**: Check if token is saved and valid
```dart
final token = await AuthService._getAuthToken();
print('Token: $token'); // Should not be null
```

### "Please wait 10 minutes" error
**Solution**: Emergency cooldown is active. This is expected behavior.

### Model parsing errors
**Solution**: Check debug logs to see raw API response
```dart
if (kDebugMode) {
  print('Response: ${response.body}');
}
```

## 📊 API Response Structure

All backend responses follow this pattern:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

Services automatically unwrap the `data` field.

## 🔐 Roles & Permissions

| Role | Can Do |
|------|---------|
| SUPER_ADMIN | Register hospitals, driver admins |
| HOSPITAL | Register patients, view patients |
| DRIVER_ADMIN | Register drivers |
| PATIENT | Trigger emergency alerts |
| DRIVER | Update location, respond to alerts, resolve emergencies |

## 📱 Next Steps

1. **Update UI Screens** to use new models
2. **Add Location Tracking** for drivers
3. **Implement Push Notifications**
4. **Add Real-time Updates** (WebSocket or polling)
5. **Improve Error Handling** with user-friendly messages
6. **Add Loading States** during API calls

## 📖 Full Documentation

See `BACKEND_INTEGRATION.md` for complete documentation including:
- All API endpoints
- Complete model structures
- Error handling
- Testing guide
- Production deployment checklist

## 🆘 Support

If you encounter issues:
1. Check backend logs in terminal
2. Check Flutter logs with `flutter run -v`
3. Verify MongoDB is running
4. Check network connectivity
5. Review `lib/examples/service_usage_examples.dart` for correct usage

---

**Status**: ✅ Ready to use!  
**Backend**: MamaAlert v0.0.1  
**Last Updated**: 2025-10-23
