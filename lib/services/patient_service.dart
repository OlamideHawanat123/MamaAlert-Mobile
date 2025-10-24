import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/patient_model.dart';

class PatientService {
  static String get baseUrl => ApiConfig.baseUrl;
  
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get patients by hospital ID (Hospital only)
  static Future<List<PatientModel>> getPatientsByHospital({
    required String hospitalId,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.patientsEndpoint}/hospital/$hospitalId';

    if (kDebugMode) {
      print('=== GET PATIENTS BY HOSPITAL ===');
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
        return data.map((e) => PatientModel.fromJson(e)).toList();
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to fetch patients');
      }
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  // Get patient by ID
  static Future<PatientModel> getPatientById({
    required String patientId,
  }) async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('Not authenticated. Please login first.');
    }

    final url = '${ApiConfig.baseUrl}${ApiConfig.patientsEndpoint}/$patientId';

    if (kDebugMode) {
      print('=== GET PATIENT BY ID ===');
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
        return PatientModel.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? 'Failed to fetch patient');
      }
    } else {
      throw Exception('Failed to fetch patient');
    }
  }
}
