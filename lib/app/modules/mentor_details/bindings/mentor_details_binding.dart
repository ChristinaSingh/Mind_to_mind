import 'package:get/get.dart';

import '../controllers/mentor_details_controller.dart';

class MentorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MentorDetailsController>(
      () => MentorDetailsController(),
    );
  }
}
