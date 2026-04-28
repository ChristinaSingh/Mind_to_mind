import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/get_user_model.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../data/apis/api_methods/api_methods.dart';

class ProfileController extends GetxController {
  UserResult? userResult;

  final count = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
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

  void clickOnMenu(int index) async {
    switch (index) {
      case 0:
        if (LocalData.userType == 'Mentee') {
          dynamic result =
              await Get.toNamed(Routes.MY_PROFILE, arguments: userResult);
          if (result != null) {
            isLoading.value = true;
            getUserProfile();
          }
        } else {
          dynamic result = await Get.toNamed(Routes.PROVIDER_MY_PROFILE,
              arguments: userResult);
          if (result != null) {
            isLoading.value = true;
            getUserProfile();
          }
        }
        break;
      case 1:
        Get.toNamed(Routes.CHANGE_PASSWORD);
        break;
      case 2:
        Get.toNamed(Routes.FAVORITE);
        break;
      case 3:
        Get.toNamed(Routes.PRIVACY_POLICY);
        break;
      case 4:
        Get.toNamed(Routes.TERMS_CONDITION);
        break;
      case 5:
        // Navigator.push(Get.context!, CupertinoPageRoute(
        //   builder: (context) {
        //     return Payment();
        //   },
        // ));
        Get.toNamed(Routes.CONTACT_US);
        break;

      default:
        Get.back();
        break;
    }
  }

  void getUserProfile() async {
    try {
      UserModel? userModel =
          await ApiMethods.getProfile(userId: LocalData.userId);
      if (userModel != null &&
          userModel.status == '1' &&
          userModel.result != null) {
        userResult = userModel.result!;
        print("get user successfully complete....");
      } else {
        print('get user failed.....');
        CommonWidgets.showMyToastMessage(
            userModel?.message ?? 'Get profile failed...');
      }
    } catch (e) {
      isLoading.value = false;
      CommonWidgets.showMyToastMessage(
          'Something went wrong. Please try again...');
    }
    isLoading.value = false;
    increment();
  }
}
