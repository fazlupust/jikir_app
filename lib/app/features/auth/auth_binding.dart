import 'package:get/get.dart';

import 'presentation/controller/auth_controller.dart';

import 'data/repository/auth_repository_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepositoryImpl>(() => AuthRepositoryImpl());
    // Inject the controller when this route is accessed
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthRepositoryImpl>()));
  }
}
