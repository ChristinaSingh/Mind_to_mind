import 'package:get/get.dart';

import '../../../data/apis/api_models/get_appointmentlist_model.dart';

class ProviderClientDetailController extends GetxController {
  GetAppointmentListResult clientData = Get.arguments;

  final count = 0.obs;
  @override
  void onInit() {
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
}
