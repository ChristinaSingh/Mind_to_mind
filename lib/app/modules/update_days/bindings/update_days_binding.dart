import 'package:get/get.dart';

import '../controllers/update_days_controller.dart';

class UpdateDaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateDaysController>(
      () => UpdateDaysController(),
    );
  }
}
