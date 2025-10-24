class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // Add null safety check
    if (json == null) {
      return LocationModel(
        latitude: 0.0,
        longitude: 0.0,
      );
    }
    
    return LocationModel(
      latitude: (json['latitude'] is num ? json['latitude'] : 0.0).toDouble(),
      longitude: (json['longitude'] is num ? json['longitude'] : 0.0).toDouble(),
      address: json['address'] is String ? json['address'] : null,
    );
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}
