import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(title: 'Password Reset'),
      body: Obx(() {
        controller.count.value;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Please put your email or mobile number to reset your password",
                  textAlign: TextAlign.center,
                  style: MyTextStyle.titleStyle16b,
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Container(
                  width: width,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                      // color:Color(0xff2EB9D5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: controller.isNumber.value
                              ? Color(0xff2EB9D5)
                              : Colors.grey,
                          width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/icons/ic_message_forget_pass.svg"),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SMS",
                              style: MyTextStyle.titleStyle16bb,
                            ),
                            Container(
                                width: width * 0.5,
                                child: TextFormField(
                                  focusNode: controller.focusMobile,
                                  controller: controller.phoneController,
                                  onTap: () {
                                    controller.type = 'Mobile';
                                    print("type is:::${controller.type}");
                                  },
                                  keyboardType: TextInputType.number,
                                )
                                // CustomTextField(
                                //   bgColor: Colors.transparent,
                                //   controller: mobileController,
                                //   hintText: "Enter Mobile number",
                                //   isEditable: !isNumber,
                                //   keyboardType: TextInputType.number,
                                // ),
                                ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Container(
                  width: width,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                      // color:Color(0xff2EB9D5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: controller.isEmail.value
                              ? Color(0xff2EB9D5)
                              : Colors.grey,
                          width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            "assets/icons/ic_email_forget_pass.svg"),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: MyTextStyle.titleStyle16bb,
                            ),
                            Container(
                                width: width * 0.5,
                                child: TextFormField(
                                  focusNode: controller.focusEmail,
                                  controller: controller.emailController,
                                  onTap: () {
                                    controller.type = 'Email';
                                    print("type is:::${controller.type}");
                                  },
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.2,
                ),
                CommonWidgets.commonElevatedButton(
                    onPressed: () {
                      controller.clickOnSave();
                    },
                    child: Text(
                      'Send',
                      style: MyTextStyle.titleStyle16bw,
                    ),
                    showLoading: controller.isLoading.value)
              ],
            ),
          ),
        );
      }),
    );
  }
}
