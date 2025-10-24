import 'user_model.dart';
import 'location_model.dart';

class DriverModel {
  final String id;
  final UserModel user;
  final String? licenseNumber;
  final String? vehicleType;
  final String? vehicleNumber;
  final LocationModel? currentLocation;
  final bool isAvailable;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverModel({
    required this.id,
    required this.user,
    this.licenseNumber,
    this.vehicleType,
    this.vehicleNumber,
    this.currentLocation,
    this.isAvailable = true,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      if (licenseNumber != null) 'licenseNumber': licenseNumber,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
      if (currentLocation != null) 'currentLocation': currentLocation!.toJson(),
      'isAvailable': isAvailable,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      licenseNumber: json['licenseNumber'],
      vehicleType: json['vehicleType'],
      vehicleNumber: json['vehicleNumber'],
      currentLocation: json['currentLocation'] != null
          ? LocationModel.fromJson(json['currentLocation'])
          : null,
      isAvailable: json['isAvailable'] ?? true,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  DriverModel copyWith({
    String? id,
    UserModel? user,
    String? licenseNumber,
    String? vehicleType,
    String? vehicleNumber,
    LocationModel? currentLocation,
    bool? isAvailable,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      user: user ?? this.user,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      currentLocation: currentLocation ?? this.currentLocation,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
