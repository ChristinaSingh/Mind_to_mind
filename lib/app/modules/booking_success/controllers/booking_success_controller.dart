import 'package:get/get.dart';

import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/t_and_c_model.dart';
import '../../../routes/app_pages.dart';

class BookingSuccessController extends GetxController {
  Map<String, String?> parameter = Get.parameters;
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

  void clickOnViewAppointment() async {
    Map<String, String> data = {
      ApiKeyConstants.appointmentId: parameter[ApiKeyConstants.appointmentId]??"",
    };
    Get.toNamed(Routes.MENTEE_APPOINTMENT_DETAILS,parameters: data);
  }
}
