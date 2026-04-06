import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // Decrease this in testing
      ));

      // Defaults
      await _remoteConfig.setDefaults(const {
        "latest_version": "1.0.0",
        "min_version": "1.0.0",
        "update_url": "",
      });

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint("Remote Config Initialization Error: $e");
    }
  }

  String get latestVersion => _remoteConfig.getString("latest_version");
  String get minVersion => _remoteConfig.getString("min_version");
  String get updateUrl => _remoteConfig.getString("update_url");

  Future<UpdateCheckResult> checkForUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      int current = _getExtendedVersionNumber(currentVersion);
      int latest = _getExtendedVersionNumber(latestVersion);
      int min = _getExtendedVersionNumber(minVersion);

      if (current < min) {
        return UpdateCheckResult.forceUpdate;
      } else if (current < latest) {
        return UpdateCheckResult.optionalUpdate;
      }

      return UpdateCheckResult.noUpdate;
    } catch (e) {
      debugPrint("Check for update error: $e");
      return UpdateCheckResult.noUpdate;
    }
  }

  int _getExtendedVersionNumber(String version) {
    try {
      // version string usually format x.y.z
      List<String> parts = version.split('.');
      if (parts.isEmpty) return 0;
      
      int major = int.tryParse(parts[0]) ?? 0;
      int minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      int patch = parts.length > 2 ? (int.tryParse(parts[2].split('+')[0]) ?? 0) : 0;
      
      return (major * 1000000) + (minor * 10000) + patch;
    } catch (e) {
      return 0;
    }
  }
}

enum UpdateCheckResult {
  noUpdate,
  optionalUpdate,
  forceUpdate,
}
