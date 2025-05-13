import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // google-services.json 파일의 값들을 여기에 직접 입력
    return const FirebaseOptions(
      apiKey: 'AIzaSyBKbNHZ-RrrC_JLxvxGvYIdBwBxOXIcSOs',
      appId: '1:659622704403:android:09d2056da956db98aad6e6',
      messagingSenderId: '659622704403',
      projectId: 'baby24-7cbf0',
      storageBucket: 'baby24-7cbf0.firebasestorage.app',
      authDomain: 'baby24-7cbf0.firebaseapp.com"',
    );
  }
}
