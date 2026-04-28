import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/modules/audio_call/controllers/audio_call_controller.dart';

import '../../../../common/common_widgets.dart';

class AudioCallView extends GetView<AudioCallController> {
  const AudioCallView({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CommonWidgets.appBar(title: 'Privacy Policy'),
        body: Obx(() {
          controller.count.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
          );
        }));
  }
}
