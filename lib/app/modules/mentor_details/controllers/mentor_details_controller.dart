import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/general_model.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/get_mentor_detail_model.dart';
import '../../../routes/app_pages.dart';

class MentorDetailsController extends GetxController {
  MentorDetailResult? mentorDetail;

  Map<String, String?> parameter = Get.parameters;

  final count = 0.obs;
  final isLoading = true.obs;
  final isBtnLoading = false.obs;
  final changeLike = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMentorDetails();
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

  Future<void> getMentorDetails() async {
    isLoading.value = true;
    increment();

    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.mentorId: parameter[ApiKeyConstants.mentorId] ?? '',
        ApiKeyConstants.userId: LocalData.userId ?? '',
      };

      MentorDetailModel? mentorDetailModel =
      await ApiMethods.getMentorDetailsApi(bodyParams: bodyParam);

      if (mentorDetailModel != null &&
          mentorDetailModel.status == '1' &&
          mentorDetailModel.result != null) {
        mentorDetail = mentorDetailModel.result!;
        log("Mentor name: ${mentorDetail?.name ?? ''}");
        log("Favorite status: ${mentorDetail!.favoriteStatus}");
      } else {
        log('Get mentor details failed.....');
        CommonWidgets.showMyToastMessage(
          mentorDetailModel?.message ?? 'Failed to load mentor details',
        );
      }
    } catch (e) {
      log('Error getting mentor details: $e');
      CommonWidgets.showMyToastMessage(
        'An error occurred while loading mentor details',
      );
    } finally {
      isLoading.value = false;
      increment();
    }
  }

  Future<void> addToFavorite() async {
    if (isBtnLoading.value) return;

    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.userId: LocalData.userId,
        ApiKeyConstants.mentorId: parameter[ApiKeyConstants.mentorId] ?? ''
      };

      log("Add to favorite params: $bodyParam");

      isBtnLoading.value = true;
      increment();

      GeneralModel? generalModel =
      await ApiMethods.addToCartApi(bodyParams: bodyParam);

      if (generalModel != null && generalModel.status == '1') {
        // Update favorite status
        final oldStatus = mentorDetail!.favoriteStatus;
        mentorDetail!.favoriteStatus = generalModel.result;

        changeLike.value = true;

        CommonWidgets.showMyToastMessage(
          generalModel.message ??
              (oldStatus == "unlike"
                  ? 'Added to favorites successfully'
                  : 'Removed from favorites successfully'),
        );

        log("Favorite status updated to: ${mentorDetail!.favoriteStatus}");
      } else {
        log('Failed to update favorite status');
        CommonWidgets.showMyToastMessage(
          generalModel?.message ?? 'Failed to update favorite status',
        );
      }
    } catch (e) {
      log('Error updating favorite: $e');
      CommonWidgets.showMyToastMessage(
        'An error occurred while updating favorites',
      );
    } finally {
      isBtnLoading.value = false;
      increment();
    }
  }

  void clickOnRequestMentor() {
    if (mentorDetail == null) {
      CommonWidgets.snackBarView(title: 'Please wait, loading mentor details');
      return;
    }

    Map<String, String> data = {
      ApiKeyConstants.mentorId: parameter[ApiKeyConstants.mentorId] ?? '',
    };

    Get.toNamed(Routes.BOOK_APPOINTMENT, parameters: data);
  }
}