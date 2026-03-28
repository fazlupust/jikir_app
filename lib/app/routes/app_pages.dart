import 'package:get/get.dart';
import '../features/auth/auth_binding.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/home/home_binding.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(
      name: '/auth',
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      binding: HomeBinding(), // Injects Home Controller & Repo
    ),
  ];
}
