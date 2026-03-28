import 'package:get/get.dart';
import 'data/repository/home_repository_impl.dart' show HomeRepositoryImpl;
import 'domain/repository/home_repository.dart';
import 'presentation/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl());
    Get.lazyPut(() => HomeController(Get.find<HomeRepository>()));
  }
}
