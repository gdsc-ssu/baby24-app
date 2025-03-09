import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:baby24_app/src/controller/notification_controller.dart';
import 'package:baby24_app/src/pages/role_selection_page.dart';
import 'package:baby24_app/src/utils/app_mode.dart';
// 나중에 사용할 import들
/*
import 'package:baby24_app/src/pages/message_page.dart';
import 'package:baby24_app/src/utils/role_handler.dart';
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // NotificationController 초기화를 여기서 실행
  Get.put(NotificationController(), permanent: true);
  
  // AppMode 컨트롤러 초기화
  Get.put(AppMode());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby24 App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RoleSelectionPage(),
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
