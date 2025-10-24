import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/emergency_alert_model.dart';

class EmergencyService {
  static String get baseUrl => ApiConfig.baseUrl;
  
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<EmergencyAlertModel> triggerEmergencyAlert({
    required String patientId,
    required double latitude,
    required double longitude,
    String? address,
    String? description,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}';
    final body = {
      'patientId': patientId,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
        if (address != null) 'address': address,
      },
      if (description != null) 'description': description,
    };

    // Debug logging
    if (kDebugMode) {
      print('=== EMERGENCY ALERT API CALL ===');
      print('URL: $url');
      print('Body: ${json.encode(body)}');
      print('Token: ${token.substring(0, 20)}...');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    // Debug logging
    if (kDebugMode) {
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final apiResponse = json.decode(response.body);
        if (kDebugMode) {
          print('API Response: $apiResponse');
        }
        if (apiResponse['success'] == true) {
          return EmergencyAlertModel.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? 'Failed to send emergency alert');
        }
      } catch (e) {
        if (kDebugMode) {
          print('JSON parsing error: $e');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to parse response: $e');
      }
    } else if (response.statusCode == 429) {
      throw Exception('Please wait 10 minutes before triggering another alert');
    } else {
      try {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to send emergency alert');
      } catch (e) {
        throw Exception('Failed to send emergency alert (Status: ${response.statusCode}) - ${response.body}');
      }
    }
  }

  static Future<List<EmergencyAlertModel>> getEmergencyHistory() async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}/history'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        final List<dynamic> data = apiResponse['data'];
        return data.map((e) => EmergencyAlertModel.fromJson(e)).toList();
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to fetch emergency history');
      }
    } else {
      throw Exception('Failed to fetch emergency history');
    }
  }

  static Future<EmergencyAlertModel> getAlertStatus(String alertId) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.emergencyAlertsEndpoint}/$alertId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final apiResponse = json.decode(response.body);
      if (apiResponse['success'] == true) {
        return EmergencyAlertModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to fetch alert status');
      }
    } else {
      throw Exception('Failed to fetch alert status');
    }
  }
}
