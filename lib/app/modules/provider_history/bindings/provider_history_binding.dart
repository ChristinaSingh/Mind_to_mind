import 'package:get/get.dart';

import '../controllers/provider_history_controller.dart';

class ProviderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderHistoryController>(
      () => ProviderHistoryController(),
    );
  }
}
