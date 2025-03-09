import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:baby24_app/src/pages/live_page.dart';
import 'package:baby24_app/src/pages/camera_page.dart';

class RoleHandler {
  static Future<Widget> determineInitialPage() async {
    final dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    
    if (dynamicLink != null) {
      // Dynamic Link로 앱이 실행된 경우 -> 카메라 모드
      return const CameraPage();
    } else {
      // 일반적으로 앱을 실행한 경우 -> 모니터링 모드
      return const LivePage();
    }
  }
} 