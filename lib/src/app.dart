import 'package:flutter/material.dart';
import 'package:baby24_app/src/controller/notification_controller.dart';
import 'package:baby24_app/src/page/message_page.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

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
