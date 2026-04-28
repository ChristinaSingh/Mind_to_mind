import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_pickImage.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/image_pick_and_crop.dart';
import '../../../../common/local_data.dart';
import '../../../../common/text_styles.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class MyProfileController extends GetxController {
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController name1Controller = TextEditingController();

  // TextEditingController name2Controller = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeDob = FocusNode();
  FocusNode focusNodeName1 = FocusNode();

  // FocusNode focusNodeName2 = FocusNode();
  final isEmail = false.obs;
  final isGender = false.obs;
  final isPhone = false.obs;
  final isDob = false.obs;
  final isName1 = false.obs;

  // final isName2 = false.obs;
  bool showPassword = true;
  final isLoading = false.obs;

  final List<String> genderList = ['Male', 'Female'];
  String selectedGender = "Male";
  String profileUrl = "";
  File? profileImg;
  UserResult userData = Get.arguments;

  void startListener() {
    focusNodeEmail.addListener(onFocusChange);
    focusNodeGender.addListener(onFocusChange);
    focusNodePhone.addListener(onFocusChange);
    focusNodeDob.addListener(onFocusChange);
    focusNodeName1.addListener(onFocusChange);
    // focusNodeName2.addListener(onFocusChange);
  }

  void onFocusChange() {
    isEmail.value = focusNodeEmail.hasFocus;
    isGender.value = focusNodeGender.hasFocus;
    isPhone.value = focusNodePhone.hasFocus;
    isDob.value = focusNodeDob.hasFocus;
    isName1.value = focusNodeName1.hasFocus;
    // isName2.value = focusNodeName2.hasFocus;
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startListener();
    setInitialData();
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

  void setInitialData() {
    accountTypeController.text = "${userData.type} Mode" ?? "";
    name1Controller.text = userData.name ?? "";
    // name2Controller.text = "";
    dobController.text = userData.dob ?? "dd-mm-yyyy";
    emailController.text = userData.email ?? "";
    phoneController.text = userData.mobile ?? "";
    genderController.text = userData.gender ?? "";
    selectedGender = userData.gender ?? "";
    profileUrl = userData.image ?? "";

    print("dob is::::${userData.gender}");
    print(" user dob is::::${selectedGender}");
    increment();
  }

  void showAlertDialog() {
    print("jjsd");
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
    profileImg = await ImagePickerAndCropper.pickImage(
      context: Get.context!,
      wantCropper: true,
      color: Theme.of(Get.context!).primaryColor,
    );
    increment();
  }

  Future<void> pickGallery() async {
    profileImg = await ImagePickerAndCropper.pickImage(
        context: Get.context!,
        wantCropper: true,
        color: Theme.of(Get.context!).primaryColor,
        pickImageFromGallery: true);
    increment();
  }

  void updateProfile() async {
    if (name1Controller.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        genderController.text.isNotEmpty) {
      Map<String, dynamic> bodyParamsForUpdate = {
        ApiKeyConstants.userId: LocalData.userId,
        ApiKeyConstants.name: name1Controller.text,
        ApiKeyConstants.dob: dobController.text,
        ApiKeyConstants.gender: selectedGender,
      };
      Map<String, File>? imageMap;
      if (profileImg != null) {
        imageMap = {'image': profileImg!};
      }
      print("request ------------------$bodyParamsForUpdate   $imageMap");
      isLoading.value = true;
      print("bodyParamsForUpdateProfileParams:::::$bodyParamsForUpdate");
      UserModel? userModel = await ApiMethods.updateMenteeProfileApi(
          bodyParams: bodyParamsForUpdate, imageMap: imageMap);
      if (userModel != null &&
          userModel.status != "0" &&
          userModel.result != null) {
        isLoading.value = false;
        Get.back(result: true);
      } else {
        isLoading.value = false;
        print("Update Failed....");
        CommonWidgets.showMyToastMessage(userModel!.message!);
      }
      isLoading.value = false;
    } else {
      CommonWidgets.showMyToastMessage('Please enter all details');
    }
  }
}
