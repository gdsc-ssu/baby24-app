class Device {
  final String deviceIdentifier;
  final String name;
  final String category;
  final bool isAlertOn;

  Device({
    required this.deviceIdentifier,
    required this.name,
    required this.category,
    this.isAlertOn = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceIdentifier: json['deviceIdentifier'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isAlertOn: json['isAlertOn'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceIdentifier': deviceIdentifier,
      'name': name,
      'category': category,
      'isAlertOn': isAlertOn,
    };
  }
}

class DeviceResponse {
  final int status;
  final String message;
  final List<Device> devices;

  DeviceResponse({
    required this.status,
    required this.message,
    required this.devices,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      devices: (json['data']['deviceDTOList'] as List)
          .map((device) => Device.fromJson(device))
          .toList(),
    );
  }
} 