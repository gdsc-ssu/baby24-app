import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:baby24_app/src/controller/notification_controller.dart';
import 'package:baby24_app/src/page/message_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby24 App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialBinding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
      home: App(),
    );
  }
}

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
