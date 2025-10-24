import 'user_model.dart';
import 'location_model.dart';

class HospitalModel {
  final String id;
  final String hospitalName;
  final String? registrationNumber;
  final LocationModel? location;
  final UserModel? adminUser;
  final String? email;
  final String? phoneNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  HospitalModel({
    required this.id,
    required this.hospitalName,
    this.registrationNumber,
    this.location,
    this.adminUser,
    this.email,
    this.phoneNumber,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospitalName': hospitalName,
      if (registrationNumber != null) 'registrationNumber': registrationNumber,
      if (location != null) 'location': location!.toJson(),
      if (adminUser != null) 'adminUser': adminUser!.toJson(),
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      registrationNumber: json['registrationNumber'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      adminUser: json['adminUser'] != null
          ? UserModel.fromJson(json['adminUser'])
          : null,
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  HospitalModel copyWith({
    String? id,
    String? hospitalName,
    String? registrationNumber,
    LocationModel? location,
    UserModel? adminUser,
    String? email,
    String? phoneNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      hospitalName: hospitalName ?? this.hospitalName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      location: location ?? this.location,
      adminUser: adminUser ?? this.adminUser,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
