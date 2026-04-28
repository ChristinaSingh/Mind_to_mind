import 'package:get/get.dart';

import '../controllers/provider_home_controller.dart';

class ProviderHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderHomeController>(
      () => ProviderHomeController(),
    );
  }
}
