import 'package:get/get.dart';

import '../controllers/provider_appointment_controller.dart';

class ProviderAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderAppointmentController>(
      () => ProviderAppointmentController(),
    );
  }
}
