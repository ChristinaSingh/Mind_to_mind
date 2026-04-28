import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/local_data.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/PushNotificationService.dart';
import '../../../../common/common_pickImage.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/image_pick_and_crop.dart';
import '../../../../common/text_styles.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodeMobile = FocusNode();
  FocusNode focusNodeName = FocusNode();
  final isEmail = false.obs;
  final isPassword = false.obs;
  final isName = false.obs;
  final isMobile = false.obs;
  final showPassword = true.obs;
  bool loader = false;
  String selectedCountry = "+968";

  void startListener() {
    focusNodeEmail.addListener(onFocusChange);
    focusNodePassword.addListener(onFocusChange);
    focusNodeMobile.addListener(onFocusChange);
    focusNodeName.addListener(onFocusChange);
  }

  void onFocusChange() {
    isEmail.value = focusNodeEmail.hasFocus;
    isPassword.value = focusNodePassword.hasFocus;
    isMobile.value = focusNodeMobile.hasFocus;
    isName.value = focusNodeName.hasFocus;
  }

  bool isAgreeCondition = false;
  final isLoading = false.obs;
  File? profileImage;

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

  void onClickSignup() {
    // Get.toNamed(AppRoutes.loginView);
  }

  void onClickLogin() {
    // Map<String, String> data = {ApiKeyConstants.type: 'Login'};
    // Get.toNamed(Routes.CHOOSE_ROLE, parameters: {'type': 'Login'});
    Get.toNamed(Routes.LOGIN);
  }

  void agreeDisagreeCondition() {
    isAgreeCondition = !isAgreeCondition;
    increment();
  }

  void showAlertDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyAlertDialog(
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                'Camera',
                style: MyTextStyle.titleStyle12gr,
              ),
              onPressed: () => clickCameraTextButtonView(),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Gallery', style: MyTextStyle.titleStyle12gr),
              onPressed: () => clickGalleryTextButtonView(),
            ),
          ],
          title: selectImageTextView(),
          content: contentTextView(),
        );
      },
    );
  }

  Widget selectImageTextView() => Text(
        'Select Image',
        style: Theme.of(Get.context!)
            .textTheme
            .displayMedium
            ?.copyWith(fontSize: 18.px),
      );

  Widget contentTextView() => Text(
        'Choose image from the options below',
        style: Theme.of(Get.context!)
            .textTheme
            .titleSmall
            ?.copyWith(fontSize: 14.px),
      );

  Future<void> clickCameraTextButtonView() async {
    pickCamera();
    Get.back();
  }

  Future<void> clickGalleryTextButtonView() async {
    pickGallery();
    Get.back();
  }

  Future<void> pickCamera() async {
    profileImage = await ImagePickerAndCropper.pickImage(
      context: Get.context!,
      wantCropper: true,
      color: Theme.of(Get.context!).primaryColor,
    );
    increment();
  }

  Future<void> pickGallery() async {
    profileImage = await ImagePickerAndCropper.pickImage(
        context: Get.context!,
        wantCropper: true,
        color: Theme.of(Get.context!).primaryColor,
        pickImageFromGallery: true);
    increment();
  }

  void clickOnSignUp() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (profileImage != null) {
        Map<String, dynamic> bodyParamsForSignUp = {
          ApiKeyConstants.name: nameController.text,
          ApiKeyConstants.email: emailController.text,
          ApiKeyConstants.mobile: mobileController.text,
          ApiKeyConstants.countryCode: selectedCountry,
          ApiKeyConstants.password: passwordController.text,
          ApiKeyConstants.registerId:
              await PushNotificationService.getToken() ?? '',
          ApiKeyConstants.lat: "",
          ApiKeyConstants.lon: "",
          ApiKeyConstants.country: 'India',
          ApiKeyConstants.type: LocalData.userType,
        };
        Map<String, File> imageMap = {'image': profileImage!};
        print("request ------------------$bodyParamsForSignUp \n  $imageMap");
        isLoading.value = true;
        print("bodyParamsForUpdateProfileParams:::::$bodyParamsForSignUp");
        UserModel? userModel = await ApiMethods.signUpApi(
            bodyParams: bodyParamsForSignUp, imageMap: imageMap);
        if (userModel != null &&
            userModel.status != "0" &&
            userModel.result != null) {
          isLoading.value = false;
          CommonWidgets.showMyToastMessage(userModel.message!);
          if (userModel.result!.type == 'Mentee') {
            //Get.back();
            Get.offNamed(Routes.LOGIN);
          } else {
            Map<String, String> data = {
              ApiKeyConstants.userId: userModel.result!.id ?? ''
            };
            Get.offNamed(Routes.ADD_DETAILS, parameters: data);
          }
        } else {
          isLoading.value = false;
          print("SignUp Failed....");
          CommonWidgets.showMyToastMessage(userModel!.message!);
        }
        isLoading.value = false;
      } else {
        CommonWidgets.showMyToastMessage('Please select profile image');
      }
    } else {
      CommonWidgets.showMyToastMessage('Please enter all fields...');
    }
  }
}
