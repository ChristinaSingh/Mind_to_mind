import 'package:get/get.dart';

import '../controllers/provider_client_detail_controller.dart';

class ProviderClientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderClientDetailController>(
      () => ProviderClientDetailController(),
    );
  }
}
