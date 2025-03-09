import 'package:get/get.dart';

class AppMode extends GetxController {
  static AppMode get to => Get.find();
  
  final _mode = ''.obs;
  String get mode => _mode.value;
  
  void setMode(String mode) {
    _mode.value = mode;
  }
} 