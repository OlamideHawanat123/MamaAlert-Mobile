import 'patient_model.dart';
import 'driver_model.dart';
import 'location_model.dart';
import 'emergency_status.dart';
import 'package:flutter/foundation.dart';

class EmergencyAlertModel {
  final String id;
  final PatientModel? patient;
  final LocationModel location;
  final EmergencyStatus status;
  final String? description;
  final DriverModel? respondingDriver;
  final List<String> notifiedDriverIds;
  final List<String> notifiedContacts;
  final DateTime? alertTime;
  final DateTime? responseTime;
  final DateTime? resolvedTime;
  final String? resolutionNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmergencyAlertModel({
    required this.id,
    this.patient,
    required this.location,
    this.status = EmergencyStatus.PENDING,
    this.description,
    this.respondingDriver,
    this.notifiedDriverIds = const [],
    this.notifiedContacts = const [],
    this.alertTime,
    this.responseTime,
    this.resolvedTime,
    this.resolutionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (patient != null) 'patient': patient!.toJson(),
      'location': location.toJson(),
      'status': status.toJson(),
      if (description != null) 'description': description,
      if (respondingDriver != null) 'respondingDriver': respondingDriver!.toJson(),
      'notifiedDriverIds': notifiedDriverIds,
      'notifiedContacts': notifiedContacts,
      if (alertTime != null) 'alertTime': alertTime!.toIso8601String(),
      if (responseTime != null) 'responseTime': responseTime!.toIso8601String(),
      if (resolvedTime != null) 'resolvedTime': resolvedTime!.toIso8601String(),
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory EmergencyAlertModel.fromJson(Map<String, dynamic> json) {
    // Add null safety and error handling
    if (json == null) {
      throw Exception('EmergencyAlertModel JSON data is null');
    }
    
    try {
      return EmergencyAlertModel(
        id: json['id'] is String ? json['id'] : '',
        patient: json['patient'] != null 
            ? PatientModel.fromJson(json['patient']) 
            : null,
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : LocationModel(latitude: 0.0, longitude: 0.0),
        status: json['status'] != null
            ? EmergencyStatus.fromJson(json['status'])
            : EmergencyStatus.PENDING,
        description: json['description'] is String ? json['description'] : null,
        respondingDriver: json['respondingDriver'] != null
            ? DriverModel.fromJson(json['respondingDriver'])
            : null,
        notifiedDriverIds: json['notifiedDriverIds'] is List
            ? List<String>.from(json['notifiedDriverIds'])
            : [],
        notifiedContacts: json['notifiedContacts'] is List
            ? List<String>.from(json['notifiedContacts'])
            : [],
        alertTime: json['alertTime'] is String
            ? DateTime.parse(json['alertTime'])
            : null,
        responseTime: json['responseTime'] is String
            ? DateTime.parse(json['responseTime'])
            : null,
        resolvedTime: json['resolvedTime'] is String
            ? DateTime.parse(json['resolvedTime'])
            : null,
        resolutionNotes: json['resolutionNotes'] is String ? json['resolutionNotes'] : null,
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] is String
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing EmergencyAlertModel: $e');
        print('JSON data: $json');
      }
      rethrow;
    }
  }

  EmergencyAlertModel copyWith({
    String? id,
    PatientModel? patient,
    LocationModel? location,
    EmergencyStatus? status,
    String? description,
    DriverModel? respondingDriver,
    List<String>? notifiedDriverIds,
    List<String>? notifiedContacts,
    DateTime? alertTime,
    DateTime? responseTime,
    DateTime? resolvedTime,
    String? resolutionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyAlertModel(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      location: location ?? this.location,
      status: status ?? this.status,
      description: description ?? this.description,
      respondingDriver: respondingDriver ?? this.respondingDriver,
      notifiedDriverIds: notifiedDriverIds ?? this.notifiedDriverIds,
      notifiedContacts: notifiedContacts ?? this.notifiedContacts,
      alertTime: alertTime ?? this.alertTime,
      responseTime: responseTime ?? this.responseTime,
      resolvedTime: resolvedTime ?? this.resolvedTime,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
