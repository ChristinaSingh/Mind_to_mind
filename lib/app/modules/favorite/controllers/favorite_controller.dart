import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/get_favorite_list_model.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class FavoriteController extends GetxController {
  List<FavoriteListResult> favoriteList = [];

  final count = 0.obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getFavorites();
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

  void getFavorites() async {
    Map<String, dynamic> bodyParam = {ApiKeyConstants.userId: LocalData.userId};
    FavoriteListModel? favoriteListModel =
        await ApiMethods.getFavoritesApi(bodyParams: bodyParam);
    if (favoriteListModel != null &&
        favoriteListModel.status == '1' &&
        favoriteListModel.result != null) {
      favoriteList = favoriteListModel.result!;
      print("Get favorites list successfully.....");
    } else {
      print('Get favorite list failed.....');
      CommonWidgets.showMyToastMessage(
          favoriteListModel?.message ?? 'Get favorites list  failed.....');
    }
    isLoading.value = false;
    increment();
  }
}
