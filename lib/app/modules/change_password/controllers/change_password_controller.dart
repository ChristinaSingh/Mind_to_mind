import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/general_model.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  FocusNode focusNodeCurrentPassword = FocusNode();
  FocusNode focusNodeNewPassword = FocusNode();
  FocusNode focusNodeCnfPassword = FocusNode();
  final isCurrentPassword = false.obs;
  final isNewPassword = false.obs;
  final isCnfPassword = false.obs;
  final showCurrentPassword = true.obs;
  final showNewPassword = true.obs;
  final showConPassword = true.obs;
  final isLoading = false.obs;
  void startListener() {
    focusNodeCurrentPassword.addListener(onFocusChange);
    focusNodeNewPassword.addListener(onFocusChange);
    focusNodeCnfPassword.addListener(onFocusChange);
  }

  void onFocusChange() {
    isCurrentPassword.value = focusNodeCurrentPassword.hasFocus;
    isNewPassword.value = focusNodeNewPassword.hasFocus;
    isCnfPassword.value = focusNodeCnfPassword.hasFocus;
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

  void changePassword() async {

    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.userId: LocalData.userId,
      ApiKeyConstants.currentPassword: currentPasswordController.text,
      ApiKeyConstants.password: conPasswordController.text,
    };
    isLoading.value = true;
    GeneralModel? generalModel =
        await ApiMethods.changePasswordApi(bodyParams: bodyParam);
    if (generalModel != null && generalModel.status == '1') {
      CommonWidgets.showMyToastMessage(generalModel.message ??
          'Change password  successfully completed.....');
      Get.back();
    } else {
      CommonWidgets.showMyToastMessage(
          generalModel?.message ?? 'Change password  failed.....');
    }
    isLoading.value = false;
    increment();
  }
}
