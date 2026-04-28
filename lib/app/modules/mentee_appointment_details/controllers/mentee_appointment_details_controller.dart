import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/appointment_details_model.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class MenteeAppointmentDetailsController extends GetxController {
  Map<String, String?> parameter = Get.parameters;

  final count = 0.obs;
  final isLoading = false.obs;
  AppointmentDetailsResult? appointmentDetailsResult;

  @override
  void onInit() {
    getAppointmentDetails();
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

  void getAppointmentDetails() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.appointmentId: parameter[ApiKeyConstants.appointmentId],
    };
    isLoading.value = true;
    AppointmentDetailsModel? appointmentDetailsModel =
        await ApiMethods.getAppointmentDetailsApi(bodyParams: bodyParam);
    if (appointmentDetailsModel != null &&
        appointmentDetailsModel.status == '1') {
      appointmentDetailsResult = appointmentDetailsModel.result;
    } else {
      CommonWidgets.showMyToastMessage(
          appointmentDetailsModel?.message ?? 'Something went wrong....');
    }
    isLoading.value = false;
    increment();
  }
}
