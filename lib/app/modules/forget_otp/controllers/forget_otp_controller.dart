import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/routes/app_pages.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class ForgetOtpController extends GetxController {
  Map<String, String?> parameter = Get.parameters;
  TextEditingController pin = TextEditingController();

  final count = 0.obs;
  final isLoading = false.obs;

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

  void clickOnNext() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.email: parameter['param'],
      ApiKeyConstants.otp: pin.text.toString()
    };
    isLoading.value = true;
    UserModel? userModel = await ApiMethods.checkOtpApi(bodyParams: bodyParam);
    if (userModel != null &&
        userModel.status == '1' &&
        userModel.result != null) {
      Map<String, String> data = {
        ApiKeyConstants.userId: userModel.result?.id ?? "",
      };
      Get.offNamed(Routes.CREATE_NEW_PASSWORD, parameters: data);
    } else {
      CommonWidgets.showMyToastMessage(
          userModel?.message ?? 'Something went wrong....');
    }
    isLoading.value = false;
    increment();
  }

}
