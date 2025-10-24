enum EmergencyStatus {
  PENDING,
  IN_PROGRESS,
  RESOLVED,
  CANCELLED;

  String toJson() => name;
  
  static EmergencyStatus fromJson(String json) {
    return EmergencyStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EmergencyStatus.PENDING,
    );
  }
}
