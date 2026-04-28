import 'package:get/get.dart';

import '../controllers/provider_my_profile_controller.dart';

class ProviderMyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderMyProfileController>(
      () => ProviderMyProfileController(),
    );
  }
}
