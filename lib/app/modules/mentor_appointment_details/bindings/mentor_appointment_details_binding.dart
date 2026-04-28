import 'package:get/get.dart';

import '../controllers/mentor_appointment_details_controller.dart';

class MentorAppointmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MentorAppointmentDetailsController>(
      () => MentorAppointmentDetailsController(),
    );
  }
}
