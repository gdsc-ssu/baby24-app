import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:baby24_io_app/src/models/device.model.dart';
import 'package:baby24_io_app/src/services/device.service.dart';

// StatelessWidget에서 StatefulWidget으로 변경
class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

// 디바이스 타입 열거형
enum DeviceType { light }

class _DevicesPageState extends State<DevicesPage> {
  // 디바이스 목록 변수 추가
  final List<Device> _devices = [];
  final DeviceService _deviceService = DeviceService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _deviceService.init();
  }

  Future<void> _loadDevices() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _deviceService.getDevices();
      setState(() {
        _devices.clear();
        _devices.addAll(response.devices);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load Device List: $e';
        _isLoading = false;
      });
      debugPrint('Error loading devices: $e');
    }
  }


  String _getDeviceIcon(String category, bool isAlertOn) {
    switch (category.toLowerCase()) {
      case 'light':
        return isAlertOn 
          ? 'assets/icons/light_bulb_on.png'  
          : 'assets/icons/light_bulb.png';    
      case 'siren':
        return isAlertOn 
          ? 'assets/icons/speaker_on.png'     
          : 'assets/icons/speaker.png';       
      default:
        return isAlertOn 
          ? 'assets/icons/light_bulb_on.png'
          : 'assets/icons/light_bulb.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Manage Smart Devices',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Load Device 버튼
            Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: _isLoading 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                    ),
                title: Text(
                  _isLoading ? 'Searching Smart Device List...' : 'Search Smart Device List',
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onTap: _isLoading ? null : _loadDevices,
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            // 디바이스 목록
            Expanded(
              child: _devices.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      device.name == "조명" ? "Light" : "Speaker",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Image.asset(
                                  _getDeviceIcon(device.category, device.isAlertOn),
                                  width: 260,
                                  height: 260,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 