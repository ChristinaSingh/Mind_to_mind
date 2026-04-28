import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/constants/image_constants.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary3Color,
        body: Obx(() {
      controller.count.value;
      return Center(
        child: CommonWidgets.appIcons(
            assetName: ImageConstants.imgSplash, height: 300.px, width: 300.px),
      );
    }));
  }
}
