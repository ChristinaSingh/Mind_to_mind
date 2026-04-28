import 'package:get/get.dart';

import '../controllers/let_get_start_controller.dart';

class LetGetStartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LetGetStartController>(
      () => LetGetStartController(),
    );
  }
}
