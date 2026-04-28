import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/local_data.dart';

class ChooseRoleController extends GetxController {
  Map<String, String?> parameter = Get.parameters;

  // Track selected role: 0 = none, 1 = Mentee, 2 = Mentor, 3 = Both
  final selectedRole = 0.obs;

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

  void onClickMentee() {
    selectedRole.value = 1;
    LocalData.userType = "Mentee";
    print("Selected: Mentee, type: ${parameter[ApiKeyConstants.type]}");
    _navigateToNextScreen();
  }

  void onClickMentor() {
    selectedRole.value = 2;
    LocalData.userType = "Mentor";
    print("Selected: Mentor, type: ${parameter[ApiKeyConstants.type]}");
    _navigateToNextScreen();
  }

  void onClickBoth() {
    selectedRole.value = 3;
    LocalData.userType = "Both";
    print("Selected: Both, type: ${parameter[ApiKeyConstants.type]}");
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (parameter[ApiKeyConstants.type] == 'Login') {
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.toNamed(Routes.SIGNUP);
    }
  }
}