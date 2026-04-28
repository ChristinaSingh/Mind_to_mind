import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/modules/nav_bar/controllers/nav_bar_controller.dart';
import 'package:mindtomind/app/routes/app_pages.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        controller.count.value;
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(50.px),
                              child: CachedNetworkImage(
                                imageUrl: controller.userResult?.image ??
                                    "https://picsum.photos/200/300",
                                fit: BoxFit.fill,
                                height: 100.px,
                                width: 100.px,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: primaryColor,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            controller.userResult?.name ?? '',
                            style: MyTextStyle.titleStyle18bb,
                          ),
                          Text(
                            controller.userResult?.email ?? '',
                            style: MyTextStyle.titleStyle14b,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/profileIconCircular.svg'),
                          title: Text(
                            'My Profile',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(0);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => MyProfile()));
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/passChangeIconCircular.svg'),
                          title: Text(
                            'Password Change',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(1);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ChangePassword()));
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/savedIconCircular.svg'),
                          title: Text(
                            'Saved',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(2);
                          },
                        ),
                        //  SizedBox(height: height*0.01,),
                        // ListTile(leading: SvgPicture.asset('assets/images/reviewIconCircular.svg'),
                        //   title: Text('Review'),
                        //   trailing: Icon(Icons.arrow_forward_ios,size: 15,),
                        //   onTap: (){
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ReviewScreen()));
                        //   },
                        // ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/privacyIconCircular.svg'),
                          title: Text(
                            'Privacy Policy',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(3);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => PrivacyPolicy()));
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/t&cIconCircular.svg'),
                          title: Text(
                            'Terms and Conditions',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(4);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => TermsConditionScreen()));
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),

                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/contactIconCircular.svg'),
                          title: Text(
                            'Contact Us',
                            style: MyTextStyle.titleStyle14bb,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            controller.clickOnMenu(5);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => ContactUs()));
                          },
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                              'assets/images/logoutIconCircular.svg'),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Logout',
                                style: MyTextStyle.titleStyle14bb,
                              ),
                              Text(
                                'Further secure your account for safety',
                                style: MyTextStyle.titleStyle14b,
                              )
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () {
                            _showDialog(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100.px,
                    )
                  ],
                ),
              );
      }),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out", style: MyTextStyle.titleStyle18bb),
          content: Text(
            "Are you sure you want to Log out?",
            style: MyTextStyle.titleStyle16b,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("No",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes", style: MyTextStyle.titleStyle16gr),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                selectedIndex.value = 0;
                Get.offNamedUntil(Routes.LET_GET_START, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
