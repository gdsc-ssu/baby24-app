import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import "firebase_options.dart";
import 'package:get/get.dart';
import 'package:baby24_io_app/src/controller/notification_controller.dart';
import 'package:baby24_io_app/src/pages/role_selection_page.dart';
import 'package:baby24_io_app/src/pages/main_screen.dart';
import 'package:baby24_io_app/src/utils/app_mode.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(NotificationController(), permanent: true);
    Get.put(AppMode());
    await Permission.camera.request();
    await Permission.microphone.request();
  } catch (e, stack) {
    print('초기화 에러: $e');
    print(stack);
    // 필요하다면 에러 화면을 띄우는 로직 추가
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby24',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const MainScreen(),
    );
  }
}

// 나중에 사용할 App 클래스
/*
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Cloud Message")),
      body: Obx(() {
        if (NotificationController.to.message.isNotEmpty) {
          return const MessageBox();
        }
        return Container();
      }),
    );
  }
}
*/
