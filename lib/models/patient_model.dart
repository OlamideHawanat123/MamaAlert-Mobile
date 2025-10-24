import 'user_model.dart';
import 'hospital_model.dart';
import 'location_model.dart';
import 'package:flutter/foundation.dart';

class PatientModel {
  final String id;
  final UserModel user;
  final HospitalModel? hospital;
  final String? bloodGroup;
  final DateTime? expectedDeliveryDate;
  final String? relativePhoneNumber;
  final String? relativeName;
  final String? relativeRelationship;
  final LocationModel? lastKnownLocation;
  final String? medicalHistory;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientModel({
    required this.id,
    required this.user,
    this.hospital,
    this.bloodGroup,
    this.expectedDeliveryDate,
    this.relativePhoneNumber,
    this.relativeName,
    this.relativeRelationship,
    this.lastKnownLocation,
    this.medicalHistory,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      if (hospital != null) 'hospital': hospital!.toJson(),
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (expectedDeliveryDate != null) 
        'expectedDeliveryDate': expectedDeliveryDate!.toIso8601String().split('T')[0],
      if (relativePhoneNumber != null) 'relativePhoneNumber': relativePhoneNumber,
      if (relativeName != null) 'relativeName': relativeName,
      if (relativeRelationship != null) 'relativeRelationship': relativeRelationship,
      if (lastKnownLocation != null) 'lastKnownLocation': lastKnownLocation!.toJson(),
      if (medicalHistory != null) 'medicalHistory': medicalHistory,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // Add null safety and error handling
    if (json == null) {
      throw Exception('PatientModel JSON data is null');
    }
    
    try {
      return PatientModel(
        id: json['id'] is String ? json['id'] : '',
        user: json['user'] != null
            ? UserModel.fromJson(json['user'])
            : UserModel(
                id: '',
                firstName: '',
                lastName: '',
                email: '',
                phoneNumber: '',
                role: Role.PATIENT,
              ),
        hospital: json['hospital'] != null 
            ? HospitalModel.fromJson(json['hospital']) 
            : null,
        bloodGroup: json['bloodGroup'] is String ? json['bloodGroup'] : null,
        expectedDeliveryDate: json['expectedDeliveryDate'] is String
            ? DateTime.parse(json['expectedDeliveryDate'])
            : null,
        relativePhoneNumber: json['relativePhoneNumber'] is String ? json['relativePhoneNumber'] : null,
        relativeName: json['relativeName'] is String ? json['relativeName'] : null,
        relativeRelationship: json['relativeRelationship'] is String ? json['relativeRelationship'] : null,
        lastKnownLocation: json['lastKnownLocation'] != null
            ? LocationModel.fromJson(json['lastKnownLocation'])
            : null,
        medicalHistory: json['medicalHistory'] is String ? json['medicalHistory'] : null,
        isActive: json['isActive'] is bool ? json['isActive'] : true,
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] is String
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing PatientModel: $e');
        print('JSON data: $json');
      }
      rethrow;
    }
  }

  PatientModel copyWith({
    String? id,
    UserModel? user,
    HospitalModel? hospital,
    String? bloodGroup,
    DateTime? expectedDeliveryDate,
    String? relativePhoneNumber,
    String? relativeName,
    String? relativeRelationship,
    LocationModel? lastKnownLocation,
    String? medicalHistory,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      user: user ?? this.user,
      hospital: hospital ?? this.hospital,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      relativePhoneNumber: relativePhoneNumber ?? this.relativePhoneNumber,
      relativeName: relativeName ?? this.relativeName,
      relativeRelationship: relativeRelationship ?? this.relativeRelationship,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
