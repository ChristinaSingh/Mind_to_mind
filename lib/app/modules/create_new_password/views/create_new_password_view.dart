import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/create_new_password_controller.dart';

class CreateNewPasswordView extends GetView<CreateNewPasswordController> {
  const CreateNewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CommonWidgets.appBar(title: 'Create New Password'),
        body: Obx(() {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: width * 0.7,
                      child: Text(
                        "Your new password must be different from previous used passwords.",
                        textAlign: TextAlign.center,
                        style: MyTextStyle.titleStyle16b,
                      )),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  focusNode: controller.focusNodePassword,
                  isCard: controller.isPassword.value,
                  controller: controller.passwordController,
                  obscureText: controller.showPassword.value,
                  hintText: "New Password",
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/ic_password.svg",
                    height: 25,
                    width: 25,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.showPassword.value =
                          !controller.showPassword.value;
                    },
                    child: SvgPicture.asset(
                      controller.showPassword.value
                          ? "assets/icons/ic_hide_pass.svg"
                          : "assets/icons/ic_show_pass.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  focusNode: controller.focusNodeCnfPassword,
                  isCard: controller.isCnfPassword.value,
                  controller: controller.cnfPasswordController,
                  obscureText: controller.showConPassword.value,
                  hintText: " Confirm Password",
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
                      controller.clickOnSave();
                    },
                    child: Text(
                      'Save',
                      style: MyTextStyle.titleStyle16bw,
                    ),
                    showLoading: controller.isLoading.value),
              ],
            ),
          );
        }));
  }
}
