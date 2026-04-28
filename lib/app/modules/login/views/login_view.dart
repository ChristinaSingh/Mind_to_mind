import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(title: 'Login'),
        body: Obx(() {
          controller.count.value;
          return Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CommonWidgets.commonTextFieldForLoginSignUP(
                      controller: controller.emailController,
                      hintText: 'example@gmail.com',
                      labelText: 'Email Address ',
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/ic_email.svg",
                        height: 22,
                        width: 22,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CommonWidgets.commonTextFieldForLoginSignUP(
                        labelText: "Password",
                        controller: controller.passwordController,
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
                        hintText: "********",
                        obscureText: controller.showPassword.value),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () => controller.onClickForgetPassword(),
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    CommonWidgets.commonElevatedButton(
                        onPressed: () {
                          if (controller.emailController.text.isNotEmpty &&
                              controller.passwordController.text.isNotEmpty) {
                            controller.onClickLogin();
                          } else {
                            CommonWidgets.snackBarView(
                                title: 'Required email and password....');
                          }
                        },
                        child: Text(
                          'Login',
                          style: MyTextStyle.titleStyle16bw,
                        ),
                        showLoading: controller.isLoading.value),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: MyTextStyle.titleStyle16b,
                        ),
                        InkWell(
                          onTap: () => controller.onClickSignup(),
                          child: Text("Sign Up",
                              style: MyTextStyle.titleStyle18gr),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Text(
                          "OR",
                          style: MyTextStyle.titleStyle16bb,
                        ),
                        Divider(),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                        width: width,
                        height: height * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffEBEBEB)),
                          //   color:bgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/ic_google.svg"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sign In with Google",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ));
        }));
  }
}
