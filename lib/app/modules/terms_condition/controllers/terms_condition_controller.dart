import 'package:get/get.dart';

import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/t_and_c_model.dart';

class TermsConditionController extends GetxController {

  final count = 0.obs;

  TandConditionResult? tandConditionResult;

  @override
  void onInit() {
    super.onInit();
    getTandCondition();
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

  Future<void> getTandCondition() async {
    TandConditionModel? tandConditionModel = await ApiMethods.tAndCApi();
    if (tandConditionModel != null && tandConditionModel.status == '1') {
      tandConditionResult = tandConditionModel.result;
      print("status  ${tandConditionResult}");
    } else {
      print('Get t and c failed.....');
    }
    increment();
  }
}
