import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = '${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}';
    final body = {
      'email': email,
      'password': password,
    };

    // Debug logging
    if (kDebugMode) {
      print('=== LOGIN API CALL ===');
      print('URL: $url');
      print('Email: $email');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    ).timeout(const Duration(seconds: 30));

    // Debug logging
    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Parsing user data...');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      
      if (kDebugMode) {
        print('Full API Response: $apiResponse');
      }
      
      // Extract data from ApiResponse wrapper
      if (apiResponse['success'] == true && apiResponse['data'] != null) {
        final data = apiResponse['data'];
        
        if (kDebugMode) {
          print('Data object: $data');
          print('User object: ${data['user']}');
        }
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);
        
        // Save token and user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', user.role.name);
        await prefs.setString('user_id', user.id);
        await prefs.setString('user_data', json.encode(user.toJson()));
        
        if (kDebugMode) {
          print('Login successful! Role: ${user.role.name}');
          print('User ID: ${user.id}');
          print('Hospital ID: ${user.hospitalId}');
          print('Full user data: ${json.encode(user.toJson())}');
        }
        
        return {
          'token': token,
          'user': user,
          'role': user.role.name,
          'userId': user.id,
        };
      } else {
        throw Exception(apiResponse['message'] ?? 'Login failed');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      } catch (e) {
        throw Exception('Login failed (Status: ${response.statusCode})');
      }
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      return UserModel.fromJson(userData);
    }
    return null;
  }

  static Future<String?> getHospitalId() async {
    final user = await getCurrentUser();
    
    if (kDebugMode) {
      print('🔍 Getting hospital ID for user: ${user?.id}, role: ${user?.role}');
      print('User hospitalId field: ${user?.hospitalId}');
    }
    
    // SIMPLIFIED: Just return user's hospitalId if exists, otherwise user ID
    // The backend should have set this during login
    final hospitalId = user?.hospitalId ?? user?.id;
    
    if (kDebugMode) {
      print('✅ Using Hospital ID: $hospitalId');
    }
    
    return hospitalId;
  }

  static Future<Map<String, dynamic>> registerSuperAdmin({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final requestBody = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
    
    print('Registering Super Admin with data: $requestBody');
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerSuperAdminEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response headers: ${response.headers}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return apiResponse['data'];
      } else {
        throw Exception(apiResponse['message'] ?? 'Registration failed');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? error.toString());
      } catch (e) {
        throw Exception('Registration failed: ${response.body}');
      }
    }
  }

  // Register Hospital (Super Admin only)
  static Future<Map<String, dynamic>> registerHospital({
    required String hospitalName,
    required String registrationNumber,
    required double latitude,
    required double longitude,
    required String address,
    required String email,
    required String phoneNumber,
    required String adminFirstName,
    required String adminLastName,
    required String adminEmail,
    required String adminPhoneNumber,
    required String adminPassword,
  }) async {
    final token = await _getAuthToken();
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.hospitalsEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'hospitalName': hospitalName,
        'registrationNumber': registrationNumber,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
        },
        'email': email,
        'phoneNumber': phoneNumber,
        'adminFirstName': adminFirstName,
        'adminLastName': adminLastName,
        'adminEmail': adminEmail,
        'adminPhoneNumber': adminPhoneNumber,
        'adminPassword': adminPassword,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return apiResponse['data'];
      } else {
        throw Exception(apiResponse['message'] ?? 'Hospital registration failed');
      }
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Hospital registration failed');
    }
  }

  // Register Driver Admin (Super Admin only)
  static Future<Map<String, dynamic>> registerDriverAdmin({
    required String organizationName,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final token = await _getAuthToken();
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.driverAdminsEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'organizationName': organizationName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return apiResponse['data'];
      } else {
        throw Exception(apiResponse['message'] ?? 'Driver Admin registration failed');
      }
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Driver Admin registration failed');
    }
  }

  // Register Driver (Driver Admin only)
  static Future<Map<String, dynamic>> registerDriver({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String licenseNumber,
    required String vehicleType,
    required String vehicleNumber,
    required String driverAdminId,
  }) async {
    final token = await _getAuthToken();
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.driversEndpoint}?driverAdminId=$driverAdminId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'licenseNumber': licenseNumber,
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return apiResponse['data'];
      } else {
        throw Exception(apiResponse['message'] ?? 'Driver registration failed');
      }
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Driver registration failed');
    }
  }

  // Register Patient (Hospital only)
  static Future<Map<String, dynamic>> registerPatient({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String bloodGroup,
    required String expectedDeliveryDate,
    required String medicalHistory,
    required String relativeName,
    required String relativePhoneNumber,
    required String relativeRelationship,
    required String hospitalId,
  }) async {
    final token = await _getAuthToken();
    
    final requestBody = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'bloodGroup': bloodGroup,
      'expectedDeliveryDate': expectedDeliveryDate,
      'medicalHistory': medicalHistory,
      'relativeName': relativeName,
      'relativePhoneNumber': relativePhoneNumber,
      'relativeRelationship': relativeRelationship,
      'hospitalId': hospitalId,
    };
    
    if (kDebugMode) {
      print('🏥 Registering Patient...');
      print('Hospital ID: $hospitalId');
      print('Request body: $requestBody');
    }
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.patientsEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );
    
    if (kDebugMode) {
      print('Patient registration response status: ${response.statusCode}');
      print('Patient registration response body: ${response.body}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return apiResponse['data'];
      } else {
        throw Exception(apiResponse['message'] ?? 'Patient registration failed');
      }
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Patient registration failed');
    }
  }

  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
