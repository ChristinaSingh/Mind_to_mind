import 'package:get/get.dart';

import '../controllers/provider_chats_controller.dart';

class ProviderChatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderChatsController>(
      () => ProviderChatsController(),
    );
  }
}
