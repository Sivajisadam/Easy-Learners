import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/_controllers/services_controller.dart';
import 'package:get/get.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServiceController());
    Get.put(BottomNavController(), permanent: true);
  }
}
