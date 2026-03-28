import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can re-run name of the flutterfire config command.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUqtSPHU09zh_Rkaa5AQ6-Tg4Kct6ZyII',
    appId: '1:591424614224:android:127bb5f9e60fd595294655',
    messagingSenderId: '591424614224',
    projectId: 'jikir-app',
    storageBucket: 'jikir-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUqtSPHU09zh_Rkaa5AQ6-Tg4Kct6ZyII',
    appId:
        '1:591424614224:android:127bb5f9e60fd595294655', // Usually iOS has its own ID, update this if you add iOS later
    messagingSenderId: '591424614224',
    projectId: 'jikir-app',
    storageBucket: 'jikir-app.firebasestorage.app',
    iosBundleId: 'com.jikir.app',
  );
}
