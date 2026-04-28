import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/time_picker_view.dart';
import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(title: 'My Profile'),
      body: Obx(() {
        controller.count.value;
        return AbsorbPointer(
          absorbing: controller.isLoading.value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: controller.profileImg == null
                              ? ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(100.px),
                                  child: CachedNetworkImage(
                                    imageUrl: controller.profileUrl ??
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
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    controller.profileImg!,
                                    fit: BoxFit.cover,
                                    height: 100.px,
                                    width: 100.px,
                                  ),
                                ),
                        ),
                        Positioned(
                            right: 20,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () async {
                                controller.showAlertDialog();
                              },
                              child: SvgPicture.asset(
                                  "assets/images/EditProfileIcon.svg"),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  CommonWidgets.commonTextFieldForLoginSignUP(
                    // focusNode: controller.focusNodeName1,
                    controller: controller.accountTypeController,
                    // isCard: controller.isName1.value,
                    hintText: '',
                    labelText: 'Account Type',
                    readOnly: true
                  ),

                  CommonWidgets.commonTextFieldForLoginSignUP(
                    focusNode: controller.focusNodeName1,
                    controller: controller.name1Controller,
                    isCard: controller.isName1.value,
                    hintText: '',
                    labelText: 'First name',
                  ),

                  // CommonWidgets.commonTextFieldForLoginSignUP(
                  //   focusNode: controller.focusNodeName2,
                  //   controller: controller.name2Controller,
                  //   isCard: controller.isName2.value,
                  //   hintText: '',
                  //   labelText: 'Second name',
                  // ),
                  CommonWidgets.commonTextFieldForLoginSignUP(
                      readOnly: true,
                      controller: controller.dobController,
                      focusNode: controller.focusNodeDob,
                      hintText: "Date Of Birth",
                      labelText: "Date Of Birth",
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            DateTime? dateTime =
                                await DatePickerView().datePickerView(
                              context: context,
                              color: Theme.of(context).primaryColor,
                              lastDate: DateTime.now(),
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1990),
                            );
                            if (dateTime != null) {
                              controller.dobController.text =
                                  DateFormat('dd/MM/yyyy').format(dateTime);
                            }
                          },
                          child: Icon(
                            Icons.date_range,
                            size: 20.px,
                            color: primaryColor,
                          ))
                  ),

                  CommonWidgets.commonTextFieldForLoginSignUP(
                      focusNode: controller.focusNodeEmail,
                      controller: controller.emailController,
                      isCard: controller.isEmail.value,
                      hintText: '',
                      labelText: 'Email',
                      readOnly: true),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CommonWidgets.commonTextFieldForLoginSignUP(
                      controller: controller.phoneController,
                      hintText: 'Mobile Number',
                      labelText: 'Mobile Number',
                      readOnly: true),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Gender',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 5.px,
                  ),
                  chooseGender(context),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CommonWidgets.commonElevatedButton(
                    showLoading: controller.isLoading.value,
                      onPressed: () {
                        controller.updateProfile();
                      },
                      child: Text(
                        'Update',
                        style: MyTextStyle.titleStyle18bw,
                      )),
                  SizedBox(
                    height: height * 0.03,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  chooseGender(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(20)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              border: InputBorder.none, // Leading icon
            ),
            value: controller.selectedGender,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: const Text(
              'Select Gender',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            isExpanded: true,
            items: controller.genderList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(
                  items,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                onTap: () {},
              );
            }).toList(),
            onChanged: (newValue) {
              controller.selectedGender = newValue.toString();
              controller.increment();
              print("selected gender is...${controller.selectedGender}");
            },
          ),
        ),
      ),
    );
  }
}
