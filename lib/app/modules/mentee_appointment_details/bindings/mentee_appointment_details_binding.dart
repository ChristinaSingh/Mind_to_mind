import 'package:get/get.dart';

import '../controllers/mentee_appointment_details_controller.dart';

class MenteeAppointmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenteeAppointmentDetailsController>(
      () => MenteeAppointmentDetailsController(),
    );
  }
}
