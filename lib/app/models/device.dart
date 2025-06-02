class Device {
  int id;
  String deviceType;
  String model;
  String osVersion;
  String uniqueId;
  DateTime lastLoginAt;
  DateTime? lastLogoutAt;

  Device({
    required this.id,
    required this.deviceType,
    required this.model,
    required this.osVersion,
    required this.uniqueId,
    required this.lastLoginAt,
    required this.lastLogoutAt
  });

  factory Device.fromMap(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      deviceType: json['deviceType'],
      model: json['model'],
      osVersion: json['osVersion'],
      uniqueId: json['uniqueId'],
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      lastLogoutAt: json['lastLogoutAt'] != null ? DateTime.parse(json['lastLogoutAt']) : null
    );
  }
}