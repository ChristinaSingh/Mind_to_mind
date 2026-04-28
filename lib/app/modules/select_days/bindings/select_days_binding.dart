import 'package:get/get.dart';

import '../controllers/select_days_controller.dart';

class SelectDaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectDaysController>(
      () => SelectDaysController(),
    );
  }
}
