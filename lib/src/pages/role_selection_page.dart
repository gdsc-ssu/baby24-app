import 'package:flutter/material.dart';
import 'package:baby24_io_app/src/pages/camera_page.dart';
import 'package:baby24_io_app/src/pages/live_page.dart';
import 'package:baby24_io_app/src/utils/app_mode.dart';
import 'package:baby24_io_app/src/services/signalling.service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  bool _isLoading = false;

  void _navigateToMonitor() {
    AppMode.to.setMode('monitor');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LivePage(),
      ),
    );
  }

  void _navigateToCamera() {
    AppMode.to.setMode('camera');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select Your Role',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _navigateToMonitor,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Monitoring Mode', style: TextStyle(
                        color: Colors.white, fontSize: 16
                      )),
                ),
                const SizedBox(height: 20),
                const Text('or'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _navigateToCamera,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Camera Mode', style: TextStyle(color: Colors.white, fontSize: 16),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 