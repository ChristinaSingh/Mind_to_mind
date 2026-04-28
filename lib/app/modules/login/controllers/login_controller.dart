import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/get_user_model.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/PushNotificationService.dart';
import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  final isEmail = false.obs;
  final showPassword = true.obs;
  final isPassword = false.obs;
  bool loader = false;

  void startListener() {
    focusNodeEmail.addListener(onFocusChange);
    focusNodePassword.addListener(onFocusChange);
  }

  void onFocusChange() {
    isEmail.value = focusNodeEmail.hasFocus;
    isPassword.value = focusNodePassword.hasFocus;
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

  void onClickSignup() {
    // Map<String, String> data = {ApiKeyConstants.type: 'SignUp'};
    // Get.toNamed(Routes.CHOOSE_ROLE, parameters: {'type': 'SignUp'});
    Get.toNamed(Routes.SIGNUP);
  }

  void onClickForgetPassword() {
    Get.toNamed(Routes.FORGET_PASSWORD);
  }

  void onClickLogin() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.email: emailController.text,
      ApiKeyConstants.password: passwordController.text,
      ApiKeyConstants.registerId:
          await PushNotificationService.getToken() ?? '',
      ApiKeyConstants.type: LocalData.userType
    };
    isLoading.value = true;
    UserModel? userModel = await ApiMethods.loginApi(bodyParams: bodyParam);
    if (userModel != null &&
        userModel.status == '1' &&
        userModel.result != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (userModel.result!.type == 'Mentee') {
        sp.setString(ApiKeyConstants.userId, userModel.result!.id!);
        sp.setString(ApiKeyConstants.type, userModel.result!.type ?? 'Mentee');
        LocalData.userId = userModel.result!.id.toString();
        LocalData.userType = userModel.result!.type ?? 'Mentee';
        Get.offAllNamed(Routes.NAV_BAR);
      } else {
        Map<String, String> data = {
          ApiKeyConstants.userId: userModel.result!.id ?? ''
        };
        if (userModel.result!.step == '1') {
          Get.offNamed(Routes.ADD_DETAILS, parameters: data);
        }
        if (userModel.result!.step == '2') {
          Get.offNamed(Routes.SELECT_DAYS, parameters: data);
        }
        if (userModel.result!.step == '3') {
          sp.setString(ApiKeyConstants.userId, userModel.result!.id!);
          sp.setString(
              ApiKeyConstants.type, userModel.result!.type ?? 'Mentee');
          LocalData.userId = userModel.result!.id.toString();
          LocalData.userType = userModel.result!.type ?? 'Mentee';
          if (sp.getString(ApiKeyConstants.userId) != null) {
            LocalData.userType =
                sp.getString(ApiKeyConstants.type) ?? 'Mentee';
            LocalData.userId = sp.getString(ApiKeyConstants.userId) ?? '';
            if (sp.getString(ApiKeyConstants.type) == 'Mentor') {
              Get.offAllNamed(Routes.PROVIDER_NAV_BAR);
            } else {
              if (LocalData.showUserScreen) {
                Get.offAllNamed(Routes.NAV_BAR);
              } else {
                Get.offAllNamed(Routes.PROVIDER_NAV_BAR);
              }
            }
          }
        }
      }
    } else {
      CommonWidgets.showMyToastMessage(
          userModel?.message ?? 'Login failed');
    }
    isLoading.value = false;
    increment();
  }
}
