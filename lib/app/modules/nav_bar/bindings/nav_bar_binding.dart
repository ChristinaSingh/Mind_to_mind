import 'package:get/get.dart';
import 'package:mindtomind/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:mindtomind/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:mindtomind/app/modules/history/controllers/history_controller.dart';
import 'package:mindtomind/app/modules/home/controllers/home_controller.dart';
import 'package:mindtomind/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/nav_bar_controller.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarController>(
      () => NavBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
    Get.lazyPut<AppointmentController>(
      () => AppointmentController(),
    );
    Get.lazyPut<FavoriteController>(
      () => FavoriteController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
