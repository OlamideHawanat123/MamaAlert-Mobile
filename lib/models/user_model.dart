enum Role {
  SUPER_ADMIN,
  HOSPITAL,
  DRIVER_ADMIN,
  PATIENT,
  DRIVER;

  String toJson() => name;
  
  static Role fromJson(String json) {
    return Role.values.firstWhere(
      (e) => e.name == json,
      orElse: () => Role.PATIENT,
    );
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final Role role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? hospitalId; // For hospital admins
  final String? driverAdminId; // For drivers

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.hospitalId,
    this.driverAdminId,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convenience getter for full name
  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (hospitalId != null) 'hospitalId': hospitalId,
      if (driverAdminId != null) 'driverAdminId': driverAdminId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: Role.fromJson(json['role'] ?? 'PATIENT'),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      hospitalId: json['hospitalId'],
      driverAdminId: json['driverAdminId'],
    );
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    Role? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? hospitalId,
    String? driverAdminId,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hospitalId: hospitalId ?? this.hospitalId,
      driverAdminId: driverAdminId ?? this.driverAdminId,
    );
  }
}
