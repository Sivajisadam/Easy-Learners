import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/_controllers/main_controller.dart';
import 'package:get/get.dart';

import '../_controllers/services_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServiceController(), permanent: true);
    Get.put(MainController(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
  }
}
