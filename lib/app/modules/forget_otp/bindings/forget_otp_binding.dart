import 'package:get/get.dart';

import '../controllers/forget_otp_controller.dart';

class ForgetOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetOtpController>(
      () => ForgetOtpController(),
    );
  }
}
