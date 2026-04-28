import 'package:get/get.dart';

import '../controllers/all_mentor_list_controller.dart';

class AllMentorListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllMentorListController>(
      () => AllMentorListController(),
    );
  }
}
