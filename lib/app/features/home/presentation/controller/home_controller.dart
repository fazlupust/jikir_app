import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/dhikr_entity.dart';
import '../../domain/repository/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;
  HomeController(this.repository);

  // Reactive state for the UI
  var count = 0.obs;
  var currentCategoryId = "subhanallah".obs;
  var currentCategoryName = "SubhanAllah".obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // Called when the user clicks the main counter button
  void onIncrement() {
    count.value++;
    _persistData();
  }

  // Load saved count for the current day and category
  Future<void> _loadInitialData() async {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int savedCount = await repository.getDhikrCount(
      currentCategoryId.value,
      today,
    );
    count.value = savedCount;
  }

  // Create the Entity and send it to the Data Layer
  void _persistData() {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    final entity = DhikrEntity(
      categoryId: currentCategoryId.value,
      categoryName: currentCategoryName.value,
      userId: uid,
      date: today,
      count: count.value,
      lastUpdated: DateTime.now(),
    );

    repository.saveDhikr(entity);
  }
}
