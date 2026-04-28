import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/general_model.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class ContactUsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeMessage = FocusNode();
  final isEmail = false.obs;
  final isName = false.obs;
  final isMessage = false.obs;
  bool showPassword = true;
  final isLoading = false.obs;
  void startListener() {
    focusNodeEmail.addListener(onFocusChange);
    focusNodeName.addListener(onFocusChange);
    focusNodeMessage.addListener(onFocusChange);
  }

  void onFocusChange() {
    isEmail.value = focusNodeEmail.hasFocus;
    isName.value = focusNodeName.hasFocus;
    isMessage.value = focusNodeMessage.hasFocus;
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

  void contactUs() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.userId: LocalData.userId,
      ApiKeyConstants.fullName: nameController.text,
      ApiKeyConstants.email: emailController.text,
      ApiKeyConstants.message: messageController.text,
    };
    isLoading.value = true;
    GeneralModel? generalModel =
        await ApiMethods.contactUsApi(bodyParams: bodyParam);
    if (generalModel != null && generalModel.status == '1') {
      print('Submit Contact  successfully complete.....');
      CommonWidgets.showMyToastMessage(
          generalModel.message ?? 'Submit Contact  successfully complete.....');
      Get.back();
    } else {
      print('Submit Contact  failed.....');
      CommonWidgets.showMyToastMessage(
          generalModel?.message ?? 'Submit Contact  failed.....');
    }
    isLoading.value = false;
    increment();
  }
}
