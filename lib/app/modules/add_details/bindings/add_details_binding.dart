import 'package:get/get.dart';

import '../controllers/add_details_controller.dart';

class AddDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDetailsController>(
      () => AddDetailsController(),
    );
  }
}
