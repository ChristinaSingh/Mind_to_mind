import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_methods/api_methods.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/local_data.dart';
import '../../../data/apis/api_models/get_banner_mode.dart';
import '../../../data/apis/api_models/get_category_model.dart';
import '../../../data/apis/api_models/get_mentor_list_model.dart';
import '../../../data/constants/icons_constant.dart';
import '../../../routes/app_pages.dart';

final changeLike = false.obs;

class HomeController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  int activeIndex = 0;
  List<MentorListResult> mentorList = [];
  GetCategoryResult? selectedCategory;
  Map<String, List<MentorListResult>> mentorListByCategory = {};
  List<MentorListResult> mentorListByCategory2 = [];
  List<GetCategoryResult> categoryList = [];
  List<BannerResult> bannerList = [];

  List<String> bannerListLocal = [
    IconConstants.icMentorOne,
    IconConstants.icMentorTwo,
    IconConstants.icMentorThree,
  ];


  final Map<String, String> categoryImageFixMap = {
    "PHYSIOTHERAPISTS": "https://s81.technorizen.com/mind2mind/uploads/images/category_IMG_52362.png",
    "PSYCHOLOGISTS": "https://s81.technorizen.com/mind2mind/uploads/images/category_IMG_46391.png",
    "SPEECH THERAPIST": "https://s81.technorizen.com/mind2mind/uploads/images/category_IMG_8602.png",
    "OCCUPATIONAL THERAPIST": "https://s81.technorizen.com/mind2mind/uploads/images/category_IMG_98315.png",
    "SOCIAL WORKER": "https://s81.technorizen.com/mind2mind/uploads/images/category_IMG_66034.png",
  };

  final count = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await getBanner();
    await getCategory();

    await getMentorList();
    isLoading.value = false;
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

  void clickOnCategoryItem(int index) {
    Map<String, String> data = {
      ApiKeyConstants.categoryId: categoryList[index].id ?? '',
      ApiKeyConstants.type: ApiKeyConstants.categoryId,
      ApiKeyConstants.title: categoryList[index].categoryName ?? '',
    };
    Get.toNamed(Routes.ALL_MENTOR_LIST, parameters: data);
  }

  void clickOnSeeAll(String type,String title) {
    Map<String, String> data = {
      ApiKeyConstants.categoryId: '',
      ApiKeyConstants.type: type ?? 'All',
      ApiKeyConstants.title: title ?? 'All Category',
    };
    Get.toNamed(Routes.ALL_MENTOR_LIST, parameters: data);
  }

  Future<void> getBanner() async {
    BannerModel? bannerModel = await ApiMethods.bannerApi();
    if (bannerModel != null && bannerModel.status == '1') {
      bannerList = bannerModel.result;
      print("status  ${bannerList}");
    } else {
      print('Get banner failed.....');
    }
    increment();
  }

  Future<void> getCategory() async {
    GetCategoryModel? categoryModel = await ApiMethods.categoryApi();

    if (categoryModel != null && categoryModel.status == '1') {
      categoryList = categoryModel.result ?? [];

      // 🔥 FIX WRONG IMAGE MAPPING LOCALLY
      for (var item in categoryList) {
        final key = item.categoryName?.toUpperCase().trim();
        if (key != null && categoryImageFixMap.containsKey(key)) {
          item.image = categoryImageFixMap[key];
        }
      }

      print("Category data fixed locally ✅");
    } else {
      print('Get category failed.....');
    }
    increment();
  }


  Future<void> getMentorList() async {
    Map<String, dynamic> bodyParam = {ApiKeyConstants.userId: LocalData.userId};

    MentorListModel? mentorListModel =
        await ApiMethods.getMentorListApi(bodyParams: bodyParam);

    if (mentorListModel != null && mentorListModel.status == '1') {
      mentorList = mentorListModel.result!;

      // 🔹 Separate data according to category_name
      mentorListByCategory.clear(); // Clear previous data before grouping

      for (var mentor in mentorList) {
        final category = mentor.categoryName ?? 'Unknown';
        mentorListByCategory.putIfAbsent(category, () => []);
        mentorListByCategory[category]!.add(mentor);
      }

      // (Optional) Print categories for debugging
      mentorListByCategory.forEach((key, value) {
        print("Category: $key → ${value.length} mentors");
      });
    } else {
      print('Get mentor list failed.....');
      CommonWidgets.showMyToastMessage(
          mentorListModel?.message ?? 'Get mentor list failed.....');
    }

    increment();
  }

  void getMentorListByCategory(String categoryId) async {
    mentorListByCategory2.clear();
    Map<String, dynamic> bodyParam = {ApiKeyConstants.categoryId: categoryId};
    MentorListModel? mentorListModel =
        await ApiMethods.getMentorListApi(bodyParams: bodyParam);
    if (mentorListModel != null && mentorListModel.status == '1') {
      mentorListByCategory2 = mentorListModel.result!;
      print("status  ${bannerList}");
    } else {
      print('Get mentor list by category failed.....');
      CommonWidgets.showMyToastMessage(mentorListModel?.message ??
          'Get mentor list by category failed.....');
    }
    increment();
  }

  void clickOnMentor(index) async {
    Map<String, String> data = {
      ApiKeyConstants.mentorId: mentorList[index].id ?? '',
      ApiKeyConstants.type: mentorList[index].categoryName ?? ''
    };

    print("data here ${mentorList[index].name}");
    changeLike.value = false;
    await Get.toNamed(Routes.MENTOR_DETAILS, parameters: data);
    if (changeLike.value) {
      getMentorList();
    }
  }

  void clickOnMentorForCategory(String id, String categoryName) async {
    Map<String, String> data = {
      ApiKeyConstants.mentorId: id ?? '',
      ApiKeyConstants.type: categoryName ?? ''
    };

    print("data here ${categoryName}");
    changeLike.value = false;
    await Get.toNamed(Routes.MENTOR_DETAILS, parameters: data);
    if (changeLike.value) {
      getMentorList();
    }
  }

  /*void addToFavorite(String mentorId) async {
    Map<String, dynamic> data = {'user_id': userId, 'mentor_id': mentorId};
    var res = await Webservices.postData(
        apiUrl: "$baseUrl$favorite_mentor", body: data, context: context);
    print("status from api get mentor${res}");
    if (res['status'] == '1') {
      showSnackbar(context, res['result']);
      getMentorList();
    } else {
      showSnackbar(context, res['message']);
    }
  }*/

  void showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary3Color,
          surfaceTintColor: primary3Color,
          title: Center(
              child: Text(
            "Switch Account",
            style: MyTextStyle.titleStyle24bb,
          )),
          content: Container(
              height: 300.px,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to switch accounts?",
                    style: MyTextStyle.titleStyle16b,
                    textAlign: TextAlign.center,
                  ),
                  SvgPicture.asset(
                    "assets/icons/ic_both.svg",
                    height: 120.px,
                    width: 120.px,
                  ),
                  CommonWidgets.commonElevatedButton(
                      onPressed: () {
                        Get.back();
                        print("Switch account");
                        LocalData.showUserScreen = false;
                        Get.offAllNamed(Routes.SPLASH);
                      },
                      child: Text(
                        'Switch',
                        style: MyTextStyle.titleStyle16bw,
                      ),
                      buttonMargin: EdgeInsets.all(5.px)),
                  CommonWidgets.commonElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: MyTextStyle.titleStyle16gr,
                      ),
                      buttonColor: Colors.transparent)
                ],
              )),
        );
      },
    );
  }
}
