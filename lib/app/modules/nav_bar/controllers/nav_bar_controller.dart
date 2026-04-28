import 'package:get/get.dart';
import 'package:mindtomind/app/modules/appointment/views/appointment_view.dart';
import 'package:mindtomind/app/modules/favorite/views/favorite_view.dart';
import 'package:mindtomind/app/modules/history/views/history_view.dart';
import 'package:mindtomind/app/modules/profile/views/profile_view.dart';

import '../../../../common/common_methods.dart';
import '../../home/views/home_view.dart';

final selectedIndex = 0.obs;

class NavBarController extends GetxController {
  //TODO: Implement NavBarController

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
    switch (selectedIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return const HistoryView();
      case 2:
        return const AppointmentView();
      // case 3:
      //   return const FavoriteView();
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
