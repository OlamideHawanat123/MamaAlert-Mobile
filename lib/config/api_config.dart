class ApiConfig {
  // Backend URL - Use local network IP for emulator/physical device connectivity
  // Using 172.16.0.168 (your machine's current IP) for emulator to connect to host machine
  static const String baseUrl = 'http://172.16.0.168:8080/api/v1';
  
  // API Endpoints - Auth
  static const String loginEndpoint = '/auth/login';
  static const String registerSuperAdminEndpoint = '/auth/register/super-admin';
  
  // API Endpoints - Emergency
  static const String emergencyAlertsEndpoint = '/emergency-alerts';
  
  // API Endpoints - Users
  static const String patientsEndpoint = '/patients';
  static const String driversEndpoint = '/drivers';
  static const String hospitalsEndpoint = '/hospitals';
  static const String driverAdminsEndpoint = '/driver-admins';
  
  // Emergency Settings
  static const double emergencyRadiusKm = 10.0;
  static const int alertCooldownMinutes = 10;
  
  // HTTP Timeout
  static const Duration timeout = Duration(seconds: 30);
}
