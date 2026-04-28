import 'package:get/get.dart';
import 'package:mindtomind/app/modules/profile/views/profile_view.dart';
import 'package:mindtomind/app/modules/provider_appointment/views/provider_appointment_view.dart';
import 'package:mindtomind/app/modules/provider_chats/views/provider_chats_view.dart';
import 'package:mindtomind/app/modules/provider_history/views/provider_history_view.dart';
import 'package:mindtomind/app/modules/provider_home/views/provider_home_view.dart';

import '../../../../common/common_methods.dart';
import '../../appointment/views/appointment_view.dart';

final selectedProviderIndex = 0.obs;

class ProviderNavBarController extends GetxController {
  //TODO: Implement ProviderNavBarController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  body() {
    switch (selectedProviderIndex.value) {
      case 0:
        return const ProviderHomeView();
      case 1:
        return const ProviderHistoryView();
      case 2:
        return const ProviderHomeView();
      case 3:
        return const ProfileView();
    }
  }

  onClickBack() {
    CommonMethods.showAlertDialog(
      title: "Exit App",
      content: "Do you want to Exit from App",
      onPressedYes: () async {
        Get.back();
      },

    );
  }
}
