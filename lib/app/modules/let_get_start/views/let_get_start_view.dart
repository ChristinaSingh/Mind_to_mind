import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/constants/image_constants.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/let_get_start_controller.dart';

class LetGetStartView extends GetView<LetGetStartController> {
  const LetGetStartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: controller.onWillPop,
        child: Obx(() {
          controller.count.value;
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonWidgets.appIcons(
                      assetName: ImageConstants.imgSplash,
                      height: 250.px,
                      width: 250.px),
                  SizedBox(height: height * 0.03),
                  Text(
                    "Let's get started!",
                    style: MyTextStyle.titleStyle24bb,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Login to continue your professional journey",
                        textAlign: TextAlign.center,
                        style: MyTextStyle.titleStyle16b,
                      )),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  CommonWidgets.commonElevatedButton(
                      //width: width,
                      onPressed: () {
                        controller.onClickLogin();
                      },
                      child: Text(
                        'Login',
                        style: MyTextStyle.titleStyle16bw,
                      )),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  InkWell(
                    onTap: () => controller.onClickSignup(),
                    child: Container(
                      width: width,
                      height: height * 0.075,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 1.5),
                        //   color:bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child:
                            //load!?CustomLoader():
                            Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: MyTextStyle.titleStyle18gr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
