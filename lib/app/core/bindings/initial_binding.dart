import 'package:get/get.dart';
import '../../data/services/database_service.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DatabaseService());
    Get.put(AuthController(), permanent: true);
  }
}
