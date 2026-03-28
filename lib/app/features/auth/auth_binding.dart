import 'package:get/get.dart';

import 'presentation/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inject the controller when this route is accessed
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
