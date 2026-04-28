import 'package:get/get.dart';

import '../controllers/select_package_controller.dart';

class SelectPackageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectPackageController>(
      () => SelectPackageController(),
    );
  }
}
