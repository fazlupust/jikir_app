import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/routes/app_pages.dart';
// 1. Import the configuration file you created
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Pass the options to the initialization method
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF08090D),
            ),
          );
        },
      ),
    );
  } catch (e) {
    debugPrint("Initialization Error: $e");
  }
}
