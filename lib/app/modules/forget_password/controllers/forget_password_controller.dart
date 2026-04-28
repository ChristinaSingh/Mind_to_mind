import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/routes/app_pages.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class ForgetPasswordController extends GetxController {
  final isEmail = false.obs;
  final isNumber = false.obs;
  String type = "";
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode focusEmail = FocusNode();
  FocusNode focusMobile = FocusNode();

  void startListener() {
    focusEmail.addListener(onFocusChange);
    focusMobile.addListener(onFocusChange);
  }

  void onFocusChange() {
    isEmail.value = focusEmail.hasFocus;
    isNumber.value = focusMobile.hasFocus;
  }

  final count = 0.obs;
  final isLoading = false.obs;

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
    if (type == "") {
      CommonWidgets.showMyToastMessage('Select the type - SMS or Email');
    } else {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.email: type == "Email"
            ? emailController.text.toString()
            : type == "Mobile"
                ? phoneController.text.toString()
                : "",
        ApiKeyConstants.type: type
      };
      isLoading.value = true;
      UserModel? userModel =
          await ApiMethods.forgetPasswordApi(bodyParams: bodyParam);
      if (userModel != null &&
          userModel.status == '1' &&
          userModel.result != null) {
        Map<String, String> data = {
          'param': type == "Email"
              ? emailController.text.toString()
              : type == "Mobile"
                  ? phoneController.text.toString()
                  : "",
          ApiKeyConstants.type: type,
        };
        Get.toNamed(Routes.FORGET_OTP, parameters: data);
      } else {
        CommonWidgets.showMyToastMessage(
            userModel?.message ?? 'Something went wrong....');
      }
      isLoading.value = false;
      increment();
    }
  }
}
