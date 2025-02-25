import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> initialize() async {
    // flavor 환경에 따라 환경 파일 로드
    await dotenv.load(fileName: '.env.${appFlavor ?? 'development'}');
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // 환경별 설정
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
}
