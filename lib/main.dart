import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import this
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // --- FCM Token Logic ---
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint("🚀 FCM TOKEN: $token"); // This prints your token to the console
    }).catchError((err) {
      debugPrint("🚀 FCM TOKEN ERROR: $err");
    });
    // -----------------------

    await Hive.initFlutter();
    await Hive.openBox('jikir_data');

    runApp(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Dhikr App",
            initialRoute: '/splash',
            getPages: AppPages.routes,
            theme: AppTheme.getTheme('dark'),
          );
        },
      ),
    );
  } catch (e) {
    debugPrint("Initialization Error: $e");
  }
}