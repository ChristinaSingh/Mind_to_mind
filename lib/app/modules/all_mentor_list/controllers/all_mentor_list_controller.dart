import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/routes/app_pages.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_mentor_list_model.dart';

class AllMentorListController extends GetxController {
  Map<String, String?> parameters = Get.parameters;
  List<MentorListResult> mentorList = [];
  TextEditingController searchController = TextEditingController();

  final count = 0.obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    if (parameters[ApiKeyConstants.type] == 'All') {
      getMentorList();
    } else {
      getMentorListByCategory(parameters[ApiKeyConstants.categoryId] ?? '');
    }
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
  void clickOnMentor(index) {
    Map<String, String> data = {
      ApiKeyConstants.mentorId: mentorList[index].id ?? '',
      ApiKeyConstants.type: mentorList[index].categoryName ?? ''
    };
    Get.toNamed(Routes.MENTOR_DETAILS, parameters: data);
  }

  void getMentorList() async {
    Map<String, dynamic> bodyParam = {};
    MentorListModel? mentorListModel =
        await ApiMethods.getMentorListApi(bodyParams: bodyParam);
    if (mentorListModel != null && mentorListModel.status == '1') {
      mentorList = mentorListModel.result!;
      print("Mentor Length....  ${mentorList.length}");
    } else {
      print('Get mentor list failed.....');
      CommonWidgets.showMyToastMessage(
          mentorListModel?.message ?? 'Get mentor list  failed.....');
    }
    isLoading.value = false;
    increment();
  }

  void getMentorListByCategory(String categoryId) async {
    mentorList.clear();
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.categoryId: categoryId,
    };
    MentorListModel? mentorListModel =
        await ApiMethods.getMentorListByCategoryApi(bodyParams: bodyParam);
    if (mentorListModel != null && mentorListModel.status == '1') {
      mentorList = mentorListModel.result!;
      print("Mentor Length....  ${mentorList.length}");
    } else {
      print('Get mentor list failed.....');
      CommonWidgets.showMyToastMessage(
          mentorListModel?.message ?? 'Get mentor list  failed.....');
    }
    isLoading.value = false;
    increment();
  }

  void searchMentor() async {
    isLoading.value = true;
    increment();
    Map<String, dynamic> bodyParam = {
      "profession": parameters[ApiKeyConstants.categoryId] ?? '',
      "text": searchController.text
    };
    MentorListModel? mentorListModel =
        await ApiMethods.currentPositionSearchApi(bodyParams: bodyParam);
    if (mentorListModel != null && mentorListModel.status == '1') {
      mentorList.clear();
      mentorList = mentorListModel.result!;
      print("Mentor Length....  ${mentorList.length}");
    } else {
      mentorList.clear();
      print('Get mentor list failed.....');
      CommonWidgets.showMyToastMessage(
          mentorListModel?.message ?? 'Get mentor list  failed.....');
    }
    isLoading.value = false;
    increment();
  }
}
