import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/choose_role_controller.dart';

class ChooseRoleView extends GetView<ChooseRoleController> {
  const ChooseRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(title: ''),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/ic_splash.png",
                height: 200,
              ),
              SizedBox(height: height * 0.03),
              Text(
                "Please select your preferred role",
                style: MyTextStyle.titleStyle16bb,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Choose the appropriate role to access your personalized dashboard",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.titleStyle16b,
                  )),
              SizedBox(
                height: height * 0.05,
              ),
              // Mentee Button
              _buildRoleButton(
                width: width,
                height: height,
                isSelected: controller.selectedRole.value == 1,
                icon: "assets/icons/ic_mentee.svg",
                iconHeight: 30,
                title: "Mentee",
                onTap: () => controller.onClickMentee(),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              // Mentor Button
              _buildRoleButton(
                width: width,
                height: height,
                isSelected: controller.selectedRole.value == 2,
                icon: "assets/icons/ic_mentor.svg",
                iconHeight: 35,
                title: "Mentor",
                onTap: () => controller.onClickMentor(),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              // Both Button
              _buildRoleButton(
                width: width,
                height: height,
                isSelected: controller.selectedRole.value == 3,
                icon: "assets/icons/ic_both.svg",
                iconHeight: 40,
                title: "Both",
                onTap: () => controller.onClickBoth(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRoleButton({
    required double width,
    required double height,
    required bool isSelected,
    required String icon,
    required double iconHeight,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          border: Border.all(
            color: primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: iconHeight,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : primaryColor,
                  fontSize: 18,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}