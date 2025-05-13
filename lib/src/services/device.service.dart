import 'package:dio/dio.dart';
import 'package:baby24_io_app/src/models/device.model.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  late final Dio _dio;
  final String _baseUrl = 'https://baby24-server-659622704403.asia-northeast3.run.app';
  bool _initialized = false;
  List<Device> _devices = [];

  void init() {
    if (_initialized) return;
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _initialized = true;
  }

  Future<DeviceResponse> getDevices() async {
    try {
      final response = await _dio.get('/api/devices/1');
      final deviceResponse = DeviceResponse.fromJson(response.data);
      _devices = deviceResponse.devices;
      return deviceResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get devices: ${e.response?.data['message']}');
      }
      throw Exception('Failed to get devices: ${e.message}');
    }
  }

  Future<void> alertOn(String userId) async {
    try {
      final response = await _dio.post('/api/devices/alert/on/$userId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to send alert: ${response.statusCode}');
      }

      for (var device in _devices) {
        if (device.category.toLowerCase() == 'light' || 
            device.category.toLowerCase() == 'siren') {
          device = Device(
            deviceIdentifier: device.deviceIdentifier,
            name: device.name,
            category: device.category,
            isAlertOn: true,
          );
        }
      }
    } catch (e) {
      debugPrint('=== Device: Error sending alert: $e ===');
      rethrow;
    }
  }
} 

Future<void> alertOff(String userId) async {
  try {
    //final response = await _dio.post('/api/devices/alert/off/$userId');
    
    if (response.statusCode != 200) {
      throw Exception('Failed to send alert off: ${response.statusCode}');
    }

    for (var device in _devices) {
      if (device.category.toLowerCase() == 'light' || 
          device.category.toLowerCase() == 'siren') {
        device = Device(
          deviceIdentifier: device.deviceIdentifier,
          name: device.name,
          category: device.category,
          isAlertOn: false,
        );
      }
    } 
  } catch (e) {
    debugPrint('=== Device: Error sending alert off: $e ===');
    rethrow;
  }
}

