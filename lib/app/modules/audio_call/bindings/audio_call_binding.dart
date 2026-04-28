import 'package:get/get.dart';
import 'package:mindtomind/app/modules/audio_call/controllers/audio_call_controller.dart';

class AudioCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioCallController>(
      () => AudioCallController(),
    );
  }
}
