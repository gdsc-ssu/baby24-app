import 'package:flutter/material.dart';
import 'package:baby24_app/src/pages/camera_page.dart';
import 'package:baby24_app/src/pages/main_screen.dart';
import 'package:baby24_app/src/utils/app_mode.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '역할을 선택해주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                AppMode.to.setMode('monitor');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('모니터링 모드'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppMode.to.setMode('camera');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CameraPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('카메라 모드'),
            ),
          ],
        ),
      ),
    );
  }
} 