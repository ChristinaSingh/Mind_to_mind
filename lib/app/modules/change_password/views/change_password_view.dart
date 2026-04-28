import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(title: 'Change Password'),
        body: Obx(() {
          controller.count.value;
          return Padding(
            padding: EdgeInsets.all(20.px),
            child: Column(
              children: [
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.currentPasswordController,
                  obscureText: controller.showCurrentPassword.value,
                  hintText: "Current Password",
                  labelText: "Current Password",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/ic_password.svg",
                    height: 25,
                    width: 25,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.showCurrentPassword.value =
                      !controller.showCurrentPassword.value;
                    },
                    child: SvgPicture.asset(
                      controller.showCurrentPassword.value
                          ? "assets/icons/ic_hide_pass.svg"
                          : "assets/icons/ic_show_pass.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.newPasswordController,
                  obscureText: controller.showNewPassword.value,
                  hintText: "New Password",
                  labelText: "New Password",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/ic_password.svg",
                    height: 25,
                    width: 25,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.showNewPassword.value =
                      !controller.showNewPassword.value;
                    },
                    child: SvgPicture.asset(
                      controller.showNewPassword.value
                          ? "assets/icons/ic_hide_pass.svg"
                          : "assets/icons/ic_show_pass.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.conPasswordController,
                  obscureText: controller.showConPassword.value,
                  hintText: "Confirm Password",
                  labelText: "Confirm Password",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/ic_password.svg",
                    height: 25,
                    width: 25,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.showConPassword.value =
                      !controller.showConPassword.value;
                    },
                    child: SvgPicture.asset(
                      controller.showConPassword.value
                          ? "assets/icons/ic_hide_pass.svg"
                          : "assets/icons/ic_show_pass.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                const Spacer(),
                CommonWidgets.commonElevatedButton(
                    onPressed: () {
                      if (controller.currentPasswordController.text == "") {
                        CommonWidgets.snackBarView(
                            title: "Enter current password");
                      } else if (controller.newPasswordController.text == "") {
                        CommonWidgets.snackBarView(title: "Enter new password");
                      } else if (controller.conPasswordController.text == "") {
                        CommonWidgets.snackBarView(
                            title: "Confirm new password");
                      } else {
                        if (controller.newPasswordController.text !=
                            controller.conPasswordController.text) {
                          CommonWidgets.snackBarView(
                              title: "New and Confirm password should be same");
                        } else {
                          controller.changePassword();
                        }
                      }
                      // Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    showLoading: controller.isLoading.value,
                    child: Text(
                      'Change',
                      style: MyTextStyle.titleStyle18bw,
                    ))
              ],
            ),
          );
        }));
  }
}
