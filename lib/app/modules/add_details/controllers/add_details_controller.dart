import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/routes/app_pages.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_category_model.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class AddDetailsController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController professionLocController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController messageController = TextEditingController(text: "");
  TextEditingController audioController = TextEditingController(text: "");
  TextEditingController videoController = TextEditingController(text: "");
  TextEditingController socialUrlController = TextEditingController();

  String? selectedGender;
  // GetCategoryResult? selectedSpacialization;
  final isLoading = false.obs;
  List<String> genderList = ["Female", "Male", "Other"];
  Map<String, String?> parameter = Get.parameters;

  GetCategoryResult? selectedSpacialization;
  List<GetCategoryResult> categoryList = [];

  final count = 0.obs;
  @override
  void onInit() {
    getCategory();
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

  void clickOnNext() {
    Get.toNamed(Routes.SELECT_DAYS);
  }

  void getCategory() async {
    GetCategoryModel? categoryModel = await ApiMethods.categoryApi();
    if (categoryModel != null &&
        categoryModel.status == '1' &&
        categoryModel.result != null) {
      categoryList = categoryModel.result!;
      print("get category successfully complete....");
    } else {
      print('get category failed.....');
    }
    increment();
  }

  void addDetails() async {
    Map<String, dynamic> bodyParamsForSignUp = {
      ApiKeyConstants.userId: parameter[ApiKeyConstants.userId] ?? '',
      ApiKeyConstants.about: descriptionController.text,
      ApiKeyConstants.lang: languageController.text,
      ApiKeyConstants.profession: selectedSpacialization!.id,
      ApiKeyConstants.exp: experienceController.text,
      ApiKeyConstants.professionLocation: professionLocController.text,
      ApiKeyConstants.currentPosition: positionController.text,
      ApiKeyConstants.dob: dobController.text,
      ApiKeyConstants.gender: selectedGender,
      ApiKeyConstants.messageRate: messageController.text,
      ApiKeyConstants.audioRate: audioController.text,
      ApiKeyConstants.videoRate: videoController.text,
      ApiKeyConstants.socialMediaUrl: socialUrlController.text
    };
    isLoading.value = true;
    print("bodyParamsForUpdateProfileParams:::::$bodyParamsForSignUp");
    UserModel? userModel =
        await ApiMethods.addDetailsApi(bodyParams: bodyParamsForSignUp);
    if (userModel != null &&
        userModel.status != "0" &&
        userModel.result != null) {
      isLoading.value = false;
      CommonWidgets.showMyToastMessage(userModel.message!);
      Map<String, String> data = {
        ApiKeyConstants.userId: userModel.result!.id ?? ''
      };
      // Get.back();
      // Get.offNamed(Routes.LOGIN);
      Get.offNamed(Routes.SELECT_DAYS, parameters: data);
    } else {
      isLoading.value = false;
      print("Add Details Failed....");
      CommonWidgets.showMyToastMessage(userModel!.message!);
    }
    isLoading.value = false;
  }
}
