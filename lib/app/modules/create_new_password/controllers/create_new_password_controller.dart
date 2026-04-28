import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/general_model.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../routes/app_pages.dart';

class CreateNewPasswordController extends GetxController {
  Map<String, String?> parameter = Get.parameters;
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfPasswordController = TextEditingController();
  FocusNode focusNodeCnfPassword = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  final isCnfPassword = false.obs;
  final isPassword = false.obs;
  final showPassword = true.obs;
  final showConPassword = true.obs;
  bool loader = false;
  final isLoading = false.obs;

  void startListener() {
    focusNodeCnfPassword.addListener(onFocusChange);
    focusNodePassword.addListener(onFocusChange);
  }

  void onFocusChange() {
    isCnfPassword.value = focusNodeCnfPassword.hasFocus;
    isPassword.value = focusNodePassword.hasFocus;
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startListener();
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

  void clickOnSave() async {
    if (passwordController.text.isEmpty) {
      CommonWidgets.showMyToastMessage('Enter New Password');
    } else if (cnfPasswordController.text.isEmpty) {
      CommonWidgets.showMyToastMessage('Confirm New Password');
    } else if (passwordController.text.toString() !=
        cnfPasswordController.text.toString()) {
      CommonWidgets.showMyToastMessage(
          'New password and confirm password should be same');
    } else {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.userId: parameter[ApiKeyConstants.userId],
        ApiKeyConstants.password: cnfPasswordController.text.toString()
      };
      isLoading.value = true;
      GeneralModel? generalModel =
          await ApiMethods.resetPasswordApi(bodyParams: bodyParam);
      if (generalModel != null && generalModel.status == '1') {
        Get.offNamed(Routes.CHOOSE_ROLE);
      } else {
        CommonWidgets.showMyToastMessage(
            generalModel?.message ?? 'Something went wrong....');
      }
      isLoading.value = false;
      increment();
    }
  }
}
