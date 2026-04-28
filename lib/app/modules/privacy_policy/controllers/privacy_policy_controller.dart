import 'package:get/get.dart';

import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/t_and_c_model.dart';

class PrivacyPolicyController extends GetxController {

  final count = 0.obs;

  TandConditionResult? privacyPolicyResult;
  @override
  void onInit() {
    super.onInit();
    getPrivacyPolicy();
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

  Future<void> getPrivacyPolicy() async {
    TandConditionModel? privacyPolicyModel = await ApiMethods.privacyPolicyApi();
    if (privacyPolicyModel != null && privacyPolicyModel.status == '1') {
      privacyPolicyResult = privacyPolicyModel.result;
      print("status  ${privacyPolicyResult}");
    } else {
      print('Get privacy policy failed.....');
    }
    increment();
  }
}
