import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class UpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final String updateUrl;

  const UpdateDialog({
    super.key,
    required this.isForceUpdate,
    required this.updateUrl,
  });

  static void show({required bool isForceUpdate, required String updateUrl}) {
    Get.dialog(
      UpdateDialog(isForceUpdate: isForceUpdate, updateUrl: updateUrl),
      barrierDismissible: !isForceUpdate,
    );
  }

  void _launchUrl() async {
    final Uri url = Uri.parse(updateUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $updateUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    return PopScope(
      canPop: !isForceUpdate,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.bdr),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.system_update,
                  size: 64,
                  color: colors.gold,
                ),
                const SizedBox(height: 16),
                Text(
                  "Update Available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.txt,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isForceUpdate
                      ? "A new version is required to continue using the app. Please update to the latest version."
                      : "A new version of the app is available. Would you like to update it now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.txt2,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (!isForceUpdate) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.txt2,
                            side: BorderSide(color: colors.bdr2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Update Later"),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _launchUrl,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.gold,
                          foregroundColor: colors.bg,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Update Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
