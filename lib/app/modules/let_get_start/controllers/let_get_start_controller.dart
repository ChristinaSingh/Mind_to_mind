import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/text_styles.dart';

class LetGetStartController extends GetxController {
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

  Future<bool> onWillPop() async {
    return showDialog<bool>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            "Do you want to exit the app?",
            style: MyTextStyle.titleStyle16bb,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: MyTextStyle.titleStyle18bb,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Yes',
                style: MyTextStyle.titleStyle18bb,
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  void onClickLogin() {
    Map<String, String> data = {ApiKeyConstants.type: 'Login'};
    Get.toNamed(Routes.CHOOSE_ROLE, parameters: data);
  }

  void onClickSignup() {
    Map<String, String> data = {ApiKeyConstants.type: 'SignUp'};
    Get.toNamed(Routes.CHOOSE_ROLE, parameters: data);
  }
}
