import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/constants/image_constants.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(title: 'Sign Up'),
        body: Obx(() {
          controller.count.value;
          return Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                        onTap: () async {
                          controller.showAlertDialog();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(55.px),
                                border: Border.all(
                                    color: primaryColor, width: 1.px)),
                            child: Stack(
                              children: [
                                controller.profileImage == null
                                    ? CommonWidgets.appIcons(
                                        assetName: ImageConstants.imgAddProfile,
                                        height: 110.px,
                                        width: 110.px,
                                        borderRadius: 55.px)
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Image.file(
                                          controller.profileImage!,
                                          fit: BoxFit.cover,
                                          height: 110.px,
                                          width: 110.px,
                                        ),
                                      ),
                                Positioned(
                                    bottom: 0.px,
                                    right: 0.px,
                                    child: Icon(
                                      Icons.add_circle,
                                      size: 30.px,
                                      color: primaryColor,
                                    ))
                              ],
                            ))),

                    SizedBox(
                      height: height * 0.03,
                    ),
                    CommonWidgets.commonTextFieldForLoginSignUP(
                      controller: controller.nameController,
                      hintText: 'test name',
                      labelText: 'Full Name',
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/ic_person.svg",
                        height: 22,
                        width: 22,
                      ),
                    ),

                    CommonWidgets.commonTextFieldForLoginSignUP(
                      controller: controller.emailController,
                      hintText: 'example@gmail.com',
                      labelText: 'Email',
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/ic_email.svg",
                        height: 22,
                        width: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 1.5.px, vertical: 5.px),
                            padding: EdgeInsets.only(bottom: 10.px),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(14.px),
                                border: Border.all(
                                    color: const Color(0xFFF5F5F5),
                                    width: 1.px)),
                            child: CountryCodePicker(
                              onChanged: (CountryCode? countryCode) {
                                controller.selectedCountry =
                                    countryCode?.dialCode ?? "";
                                print(
                                    "selected country code is...${controller.selectedCountry}");
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'OM',
                              padding: EdgeInsets.all(0),
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonWidgets.commonTextFieldForLoginSignUP(
                              controller: controller.mobileController,
                              hintText: '1234567890',
                              maxLength: 10,
                              labelText: 'Mobile Number',
                              prefixIcon: SvgPicture.asset(
                                "assets/icons/ic_mobile.svg",
                                height: 22,
                                width: 22,
                              ),
                              keyboardType: TextInputType.phone),
                        ),
                      ],
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

                    // showCountryList(),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.all(1),
                      title: RichText(
                        text: TextSpan(
                          text: 'I agree to the medidoc ',
                          style: MyTextStyle.titleStyle16b
                              .copyWith(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: MyTextStyle.titleStyle16b.copyWith(
                                color: Colors.blue, // Link color
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url =
                                      'https://s81.technorizen.com/mind2mind/webservice/get_terms_conditions'; // Replace with your URL
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    print('Could not launch $url');
                                  }
                                },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: MyTextStyle.titleStyle16b
                                  .copyWith(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: MyTextStyle.titleStyle16b.copyWith(
                                color: Colors.blue, // Link color
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url =
                                      'https://s81.technorizen.com/mind2mind/webservice/get_privacy_policy'; // Replace with your URL
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    print('Could not launch $url');
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                      // The text or label you want to display
                      value: controller.isAgreeCondition,
                      // The current state of the checkbox
                      onChanged: (newValue) {
                        controller.agreeDisagreeCondition();
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: primaryColor,
                      // Align the checkbox to the right of the text
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius to make it more or less rounded// Border color when unchecked
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),

                    CommonWidgets.commonElevatedButton(
                        onPressed: () {
                          controller.clickOnSignUp();
                        },
                        child: Text(
                          'Sign Up',
                          style: MyTextStyle.titleStyle18bw,
                        ),
                        showLoading: controller.isLoading.value),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: MyTextStyle.titleStyle16b,
                        ),
                        InkWell(
                          onTap: () => controller.onClickLogin(),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        }));
  }
}
