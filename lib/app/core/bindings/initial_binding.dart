import 'package:get/get.dart';
import '../../data/services/database_service.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(Get.find()), permanent: true);
  }
}
