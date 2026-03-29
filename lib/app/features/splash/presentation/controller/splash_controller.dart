import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  var appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initSplash();
  }

  void _initSplash() async {
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion.value = 'v${info.version}';
    } catch (_) {
      appVersion.value = 'v1.0.0'; // Fallback
    }
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/auth');
    }
  }
}
