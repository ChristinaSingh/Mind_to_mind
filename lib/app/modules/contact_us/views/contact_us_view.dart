import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(title: 'Contact Us'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CommonWidgets.commonElevatedButton(
            onPressed: () {
              if (controller.nameController.text == "") {
                CommonWidgets.snackBarView(title: "Enter Full name");
              } else if (controller.emailController.text == "") {
                CommonWidgets.snackBarView(title: "Enter Email");
              } else if (controller.messageController.text == "") {
                CommonWidgets.snackBarView(title: "Enter Message");
              } else {
                controller.contactUs();
              }
            },
            child: Text(
              'Submit',
              style: MyTextStyle.titleStyle18bw,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/contactUsImage.png"),
              SizedBox(
                height: height * 0.05,
              ),
              CommonWidgets.commonTextFieldForLoginSignUP(
                focusNode: controller.focusNodeName,
                controller: controller.nameController,
                isCard: controller.isName.value,
                hintText: "Full Name",
                labelText: "Full Name",
                prefixIcon: SvgPicture.asset(
                  "assets/images/profileIcon.svg",
                  height: 25,
                  width: 25,
                ),
              ),
              CommonWidgets.commonTextFieldForLoginSignUP(
                focusNode: controller.focusNodeEmail,
                controller: controller.emailController,
                isCard: controller.isEmail.value,
                hintText: "Email",
                labelText: "Email",
                prefixIcon: SvgPicture.asset(
                  "assets/images/emailIcon.svg",
                  height: 25,
                  width: 25,
                ),
              ),
              CommonWidgets.commonTextFieldForLoginSignUP(
                focusNode: controller.focusNodeMessage,
                controller: controller.messageController,
                isCard: controller.isMessage.value,
                hintText: 'Enter your message',
                labelText: 'Enter your message',
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
