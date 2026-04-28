import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/get_user_model.dart';
import 'package:mindtomind/common/local_data.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_pickImage.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/image_pick_and_crop.dart';
import '../../../../common/text_styles.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_category_model.dart';
import '../../../routes/app_pages.dart';

class ProviderMyProfileController extends GetxController {
  // Text Controllers
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController profLocController = TextEditingController();
  TextEditingController currPosController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController msgRateController = TextEditingController();
  TextEditingController audioRateController = TextEditingController();
  TextEditingController videoRateController = TextEditingController();
  TextEditingController socialUrlController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isNavigating = false.obs;
  final isInitializing = true.obs;
  final count = 0.obs;

  // Data variables
  final List<String> genderList = ['Male', 'Female', 'Other'];
  String selectedGender = "Male";
  String profileUrl = "";
  GetCategoryResult? selectedProfession;
  List<GetCategoryResult> categoryList = [];
  File? profileImg;
  late UserResult userData;

  @override
  void onInit() {
    super.onInit();
    try {
      userData = Get.arguments as UserResult;
      setInitialValue();
      getCategory();
    } catch (e) {
      print("Error initializing: $e");
      CommonWidgets.showMyToastMessage("Error loading profile data");
      isInitializing.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose controllers
    accountTypeController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    languageController.dispose();
    professionController.dispose();
    experienceController.dispose();
    profLocController.dispose();
    currPosController.dispose();
    dobController.dispose();
    genderController.dispose();
    ageController.dispose();
    msgRateController.dispose();
    audioRateController.dispose();
    videoRateController.dispose();
    socialUrlController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> getCategory() async {
    try {
      isInitializing.value = true;

      GetCategoryModel? categoryModel = await ApiMethods.categoryApi();

      if (categoryModel != null &&
          categoryModel.status == '1' &&
          categoryModel.result != null &&
          categoryModel.result!.isNotEmpty) {
        categoryList = categoryModel.result!;

        // Find and set selected profession
        try {
          if (userData.profession != null && userData.profession!.isNotEmpty) {
            selectedProfession = categoryList.firstWhere(
                  (element) => element.id == userData.profession,
              orElse: () => categoryList.first,
            );
            increment();
          } else {
            selectedProfession = categoryList.first;
            increment();
          }
        } catch (e) {
          print("Error finding profession: $e");
          selectedProfession = categoryList.isNotEmpty ? categoryList.first : null;
        }

        print("Categories loaded successfully: ${categoryList.length}");
        print("Selected profession: ${selectedProfession?.categoryName}");
      } else {
        print('Failed to get categories');
        CommonWidgets.showMyToastMessage("Failed to load specializations");
      }
    } catch (e) {
      print("Error getting categories: $e");
      CommonWidgets.showMyToastMessage("Error loading specializations");
    } finally {
      isInitializing.value = false;
      increment();
    }
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
    Get.back();
    await pickCamera();
  }

  Future<void> clickGalleryTextButtonView() async {
    Get.back();
    await pickGallery();
  }

  Future<void> pickCamera() async {
    try {
      profileImg = await ImagePickerAndCropper.pickImage(
        context: Get.context!,
        wantCropper: true,
        color: Theme.of(Get.context!).primaryColor,
      );
      increment();
    } catch (e) {
      print("Error picking camera image: $e");
      CommonWidgets.showMyToastMessage("Failed to capture image");
    }
  }

  Future<void> pickGallery() async {
    try {
      profileImg = await ImagePickerAndCropper.pickImage(
        context: Get.context!,
        wantCropper: true,
        color: Theme.of(Get.context!).primaryColor,
        pickImageFromGallery: true,
      );
      increment();
    } catch (e) {
      print("Error picking gallery image: $e");
      CommonWidgets.showMyToastMessage("Failed to select image");
    }
  }

  void setInitialValue() {
    try {
      accountTypeController.text = userData.type != null
          ? "${userData.type} Mode"
          : "User Mode";
      nameController.text = userData.name ?? "";
      emailController.text = userData.email ?? "";
      phoneController.text = userData.mobile ?? "";
      aboutController.text = userData.about ?? "";
      languageController.text = userData.lang ?? "";
      experienceController.text = userData.exp ?? "";
      profLocController.text = userData.professionLocation ?? "";
      currPosController.text = userData.currentPosition ?? "";
      dobController.text = userData.dob ?? "";
      genderController.text = userData.gender ?? "";

      // Set selected gender with validation
      if (userData.gender != null &&
          genderList.contains(userData.gender)) {
        selectedGender = userData.gender!;
      } else {
        selectedGender = genderList.first;
      }

      msgRateController.text = userData.messageRate ?? "";
      audioRateController.text = userData.audioRate ?? "";
      videoRateController.text = userData.videoRate ?? "";
      socialUrlController.text = userData.socialMediaUrl ?? "";
      profileUrl = userData.image ?? "";

      print("Profile data initialized successfully");
    } catch (e) {
      print("Error setting initial values: $e");
    }
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter your name');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter your email');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter your phone number');
      return false;
    }

    if (dobController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please select your date of birth');
      return false;
    }

    if (aboutController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter about yourself');
      return false;
    }

    if (selectedProfession == null) {
      CommonWidgets.showMyToastMessage('Please select your specialization');
      return false;
    }

    if (languageController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter languages known');
      return false;
    }

    if (profLocController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please select profession location');
      return false;
    }

    if (msgRateController.text.trim().isEmpty) {
      CommonWidgets.showMyToastMessage('Please enter message rate');
      return false;
    }

    // Validate rate values are numbers
    try {
      if (msgRateController.text.isNotEmpty) {
        double.parse(msgRateController.text);
      }
      if (audioRateController.text.isNotEmpty) {
        double.parse(audioRateController.text);
      }
      if (videoRateController.text.isNotEmpty) {
        double.parse(videoRateController.text);
      }
    } catch (e) {
      CommonWidgets.showMyToastMessage('Please enter valid rate amounts');
      return false;
    }

    return true;
  }

  Future<void> updateProfile() async {
    // Validate inputs
    if (!_validateInputs()) {
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> bodyParamsForUpdate = {
        ApiKeyConstants.userId: LocalData.userId,
        ApiKeyConstants.name: nameController.text.trim(),
        ApiKeyConstants.mobile: phoneController.text.trim(),
        ApiKeyConstants.about: aboutController.text.trim(),
        ApiKeyConstants.lang: languageController.text.trim(),
        ApiKeyConstants.profession: selectedProfession?.id ?? "",
        ApiKeyConstants.professionLocation: profLocController.text.trim(),
        ApiKeyConstants.currentPosition: currPosController.text.trim(),
        ApiKeyConstants.dob: dobController.text.trim(),
        ApiKeyConstants.gender: selectedGender,
        ApiKeyConstants.messageRate: msgRateController.text.trim(),
        ApiKeyConstants.audioRate: audioRateController.text.trim().isEmpty
            ? "0"
            : audioRateController.text.trim(),
        ApiKeyConstants.videoRate: videoRateController.text.trim().isEmpty
            ? "0"
            : videoRateController.text.trim(),
        ApiKeyConstants.socialMediaUrl: socialUrlController.text.trim(),
      };

      // Add experience if provided
      if (experienceController.text.trim().isNotEmpty) {
        bodyParamsForUpdate[ApiKeyConstants.exp] = experienceController.text.trim();
      }

      Map<String, File>? imageMap;
      if (profileImg != null) {
        imageMap = {'image': profileImg!};
      }

      print("Updating profile with params: $bodyParamsForUpdate");

      UserModel? userModel = await ApiMethods.updateProfileApi(
        bodyParams: bodyParamsForUpdate,
        imageMap: imageMap,
      );

      if (userModel != null &&
          userModel.status != "0" &&
          userModel.result != null) {
        CommonWidgets.showMyToastMessage("Profile updated successfully");

        // Update local data
        userData = userModel.result!;
        profileImg = null; // Clear the temporary image

        // Go back with success result
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        CommonWidgets.showMyToastMessage(
          userModel?.message ?? "Failed to update profile",
        );
      }
    } catch (e) {
      print("Error updating profile: $e");
      CommonWidgets.showMyToastMessage("Error updating profile. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTime() async {
    try {
      isNavigating.value = true;

      // Small delay to show loading state
      await Future.delayed(const Duration(milliseconds: 200));

      final result = await Get.toNamed(Routes.UPDATE_DAYS);

      // Handle result if needed
      if (result != null) {
        print("Time update result: $result");
      }
    } catch (e) {
      print("Error navigating to update time: $e");
      CommonWidgets.showMyToastMessage("Failed to open time slots");
    } finally {
      isNavigating.value = false;
    }
  }
}