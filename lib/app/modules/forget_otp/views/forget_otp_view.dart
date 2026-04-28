import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/apis/api_constants/api_key_constants.dart';
import '../controllers/forget_otp_controller.dart';

class ForgetOtpView extends GetView<ForgetOtpController> {
  const ForgetOtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(
          title: 'Check your ${controller.parameter[ApiKeyConstants.type]}'),
      body: Obx(() {
        controller.count.value;
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Please put the 4 digits sent to you",
                  style: MyTextStyle.titleStyle16b,
                ),
              ),
              SizedBox(
                height: height * 0.08,
              ),
              // _otp_field()
              CommonWidgets.commonOtpView(
                  controller: controller.pin, width: 60.px, height: 60.px),
              const Spacer(),
              CommonWidgets.commonElevatedButton(
                  onPressed: () {
                    controller.clickOnNext();
                  },
                  child: Text(
                    'Next',
                    style: MyTextStyle.titleStyle16bw,
                  ),
                  buttonMargin:
                      EdgeInsets.symmetric(horizontal: 5.px, vertical: 20.px),
                  showLoading: controller.isLoading.value)
            ],
          ),
        );
      }),
    );
  }
}
