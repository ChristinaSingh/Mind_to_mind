import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/text_styles.dart';
import '../controllers/nav_bar_controller.dart';

class NavBarView extends GetView<NavBarController> {
  const NavBarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.count.value;
      return WillPopScope(
        onWillPop: () async {
          return await controller.onClickBack();
        },
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: controller.body(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: primary3Color,
              borderRadius: BorderRadius.circular(0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 18.px, vertical: 8.px),
                child: GNav(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.px, vertical: 4.px),
                  tabs: [
                    button(
                        selectImage: 'assets/images/homeIconColored.svg',
                        image: 'assets/images/homeIconGrey.svg',
                        text: 'Home',
                        index: 0),
                    button(
                        selectImage: 'assets/images/historyIconColored.svg',
                        image: 'assets/images/historyIconGrey.svg',
                        text: 'History',
                        index: 1),
                    button(
                        selectImage: 'assets/images/appointmentIconColored.svg',
                        image: 'assets/images/appointmentIconGrey.svg',
                        text: 'Appointment',
                        index: 2),
                    // button(
                    //     selectImage: 'assets/images/likeIconColored.svg',
                    //     image: 'assets/images/likeIconGrey.svg',
                    //     text: 'Favourites',
                    //     index: 3),
                    button(
                        selectImage: 'assets/images/proficeIconColored.svg',
                        image: 'assets/images/profileIconGrey.svg',
                        text: 'Profile',
                        index: 3),
                  ],
                  selectedIndex: selectedIndex.value,
                  onTabChange: (index) {
                    selectedIndex.value = index;
                    controller.increment();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  button({
    required String selectImage,
    required String image,
    required String text,
    required int index,
  }) {
    return GButton(
      icon: Icons.add,
      leading: Column(
        children: [
          SvgPicture.asset(selectedIndex.value == index ? selectImage : image,
              width: 25.px, height: 25.px, fit: BoxFit.fill),
          SizedBox(
            height: 5.px,
          ),
          Text(
            text,
            style: selectedIndex.value == index
                ? MyTextStyle.titleStyleCustom(
                    12,
                    FontWeight.w500,
                    primaryColor,
                  )
                : MyTextStyle.titleStyleCustom(
                    12, FontWeight.w400, const Color(0xFF484C52)),
          )
        ],
      ),
    );
  }
}
