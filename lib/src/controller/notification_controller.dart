import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  RxMap<String, dynamic> message = <String, dynamic>{}.obs;

  @override
  void onInit() {
    _initNotification();
    _getToken();
    super.onInit();
  }

  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        print("FCM token: $token");
      }
    } catch (e) {
      print("Failed to get token: $e");
    }
  }

  void _initNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Push notification permission granted');
    } else {
      print('Push notification permission denied');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New FCM token: $newToken");
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
      _actionOnNotification(message.data);
    });

    // Handle background messages when app is opened by notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.data}");
      _actionOnNotification(message.data);
    });
  }

  void _actionOnNotification(Map<String, dynamic> messageMap) {
    message(messageMap);
  }
}
