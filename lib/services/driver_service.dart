import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/driver_model.dart';
import '../models/emergency_alert_model.dart';

class DriverService {
  static String get baseUrl => ApiConfig.baseUrl;
  
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Update driver's current location
  static Future<DriverModel> updateDriverLocation({
    required String driverId,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.driversEndpoint}/$driverId/location';
    final body = {
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
    };

    if (kDebugMode) {
      print('=== UPDATE DRIVER LOCATION ===');
      print('URL: $url');
      print('Body: ${json.encode(body)}');
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return DriverModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to update location');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update location');
      } catch (e) {
        throw Exception('Failed to update location (Status: ${response.statusCode})');
      }
    }
  }

  // Update driver's availability status
  static Future<DriverModel> updateDriverAvailability({
    required String driverId,
    required bool isAvailable,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.driversEndpoint}/$driverId/availability?isAvailable=$isAvailable';

    if (kDebugMode) {
      print('=== UPDATE DRIVER AVAILABILITY ===');
      print('URL: $url');
      print('IsAvailable: $isAvailable');
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return DriverModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to update availability');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update availability');
      } catch (e) {
        throw Exception('Failed to update availability (Status: ${response.statusCode})');
      }
    }
  }

  // Get emergency alerts for a specific driver
  static Future<List<EmergencyAlertModel>> getDriverEmergencyAlerts({
    required String driverId,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}/driver/$driverId';

    if (kDebugMode) {
      print('=== GET DRIVER EMERGENCY ALERTS ===');
      print('URL: $url');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        final List<dynamic> data = apiResponse['data'];
        return data.map((e) => EmergencyAlertModel.fromJson(e)).toList();
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to fetch emergency alerts');
      }
    } else {
      throw Exception('Failed to fetch emergency alerts');
    }
  }

  // Driver responds to an emergency alert
  static Future<EmergencyAlertModel> respondToEmergency({
    required String alertId,
    required String driverId,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}/$alertId/respond?driverId=$driverId';

    if (kDebugMode) {
      print('=== RESPOND TO EMERGENCY ===');
      print('URL: $url');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return EmergencyAlertModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to respond to emergency');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to respond to emergency');
      } catch (e) {
        throw Exception('Failed to respond to emergency (Status: ${response.statusCode})');
      }
    }
  }

  // Driver marks emergency as resolved
  static Future<EmergencyAlertModel> resolveEmergency({
    required String alertId,
    required String driverId,
    String? resolutionNotes,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}/resolve';
    final body = {
      'alertId': alertId,
      'driverId': driverId,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
    };

    if (kDebugMode) {
      print('=== RESOLVE EMERGENCY ===');
      print('URL: $url');
      print('Body: ${json.encode(body)}');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return EmergencyAlertModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to resolve emergency');
      }
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to resolve emergency');
      } catch (e) {
        throw Exception('Failed to resolve emergency (Status: ${response.statusCode})');
      }
    }
  }
}
