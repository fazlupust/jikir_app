import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../common/presentation/widgets/update_dialog.dart';

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

    final remoteConfig = RemoteConfigService();
    
    // Run the network config and a minimum 1.5-second UI delay in parallel
    // This stops them from adding up to 3+ seconds!
    final results = await Future.wait([
      Future(() async {
        await remoteConfig.initialize();
        return await remoteConfig.checkForUpdate();
      }),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);

    final updateResult = results[0] as UpdateCheckResult;

    _navigateToNext(updateResult, remoteConfig.updateUrl);
  }

  void _navigateToNext(UpdateCheckResult updateResult, String updateUrl) async {

    if (FirebaseAuth.instance.currentUser != null) {
      await Get.offAllNamed('/home');
    } else {
      await Get.offAllNamed('/auth');
    }

    if (updateResult == UpdateCheckResult.forceUpdate) {
      UpdateDialog.show(isForceUpdate: true, updateUrl: updateUrl);
    } else if (updateResult == UpdateCheckResult.optionalUpdate) {
      UpdateDialog.show(isForceUpdate: false, updateUrl: updateUrl);
    }
  }
}
