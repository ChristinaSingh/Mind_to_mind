import 'package:get/get.dart';
import 'package:mindtomind/app/modules/profile/controllers/profile_controller.dart';
import 'package:mindtomind/app/modules/provider_appointment/controllers/provider_appointment_controller.dart';
import 'package:mindtomind/app/modules/provider_chats/controllers/provider_chats_controller.dart';
import 'package:mindtomind/app/modules/provider_history/controllers/provider_history_controller.dart';
import 'package:mindtomind/app/modules/provider_home/controllers/provider_home_controller.dart';

import '../controllers/provider_nav_bar_controller.dart';

class ProviderNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderNavBarController>(
      () => ProviderNavBarController(),
    );
    Get.lazyPut<ProviderHomeController>(
      () => ProviderHomeController(),
    );
    Get.lazyPut<ProviderHistoryController>(
      () => ProviderHistoryController(),
    );
    Get.lazyPut<ProviderChatsController>(
      () => ProviderChatsController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<ProviderAppointmentController>(
      () => ProviderAppointmentController(),
    );
  }
}
