import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/time_picker_view.dart';
import '../../../data/apis/api_models/get_category_model.dart';
import '../controllers/add_details_controller.dart';

class AddDetailsView extends GetView<AddDetailsController> {
  const AddDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Obx(() {
      controller.count.value;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(title: 'Your Details'),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: CommonWidgets.commonElevatedButton(
                onPressed: () {
                  if (controller.descriptionController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter description');
                  } else if (controller.selectedGender == null) {
                    CommonWidgets.snackBarView(title: 'Choose gender');
                  } else if (controller.dobController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Choose Date of birth');
                  } else if (controller.languageController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter language');
                  }
                  else if (controller.selectedSpacialization == null) {
                    CommonWidgets.snackBarView(title: 'Choose specialization');
                  }
                  else if (controller.experienceController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter Experience');
                  } else if (controller.professionLocController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter workplace');
                  } else if (controller.positionController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter current position');
                  } else if (controller.messageController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter message rate');
                  } else if (controller.audioController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter audio rate');
                  } else if (controller.videoController.text.isEmpty) {
                    CommonWidgets.snackBarView(title: 'Enter video rate');
                  } else {
                    controller.addDetails();
                    //controller.clickOnNext();
                  }
                },
                child: Text(
                  'Next',
                  style: MyTextStyle.titleStyle18bw,
                ),
                showLoading: controller.isLoading.value)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.descriptionController,
                  hintText: "Description",
                  labelText: "Description",
                  maxLines: 5,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  'Gender',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 5.px,
                ),
                chooseGender(context),
                SizedBox(
                  height: height * 0.01,
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  onTap: () async {
                    DateTime? dateTime =
                        await DatePickerView().datePickerView(
                      context: context,
                      color: Theme.of(context).primaryColor,
                      lastDate: DateTime.now(),
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1930),
                    );
                    if (dateTime != null) {
                      controller.dobController.text =
                          DateFormat('dd/MM/yyyy').format(dateTime);
                    }
                  },
                    readOnly: true,
                    controller: controller.dobController,
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
                            firstDate: DateTime(1930),
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
                    // suffixIcon: "assets/images/calendarIcon.svg",

                    ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.languageController,
                  hintText: "Languages spoken",
                  labelText: "Languages spoken",
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  'Profession',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 5.px,
                ),
                showSpecializationList(context),
                SizedBox(
                  height: height * 0.02,
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.experienceController,
                  hintText: "Experience",
                  labelText: "Experience",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.professionLocController,
                  hintText: "Workplace (City, State/Province, Country)",
                  labelText: "Workplace (City, State/Province, Country)",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.positionController,
                  hintText: "Current Position",
                  labelText: "Current Position",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: controller.messageController,
                  hintText: "Message Rate/hour",
                  labelText: "Message Rate/hour",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  keyboardType: TextInputType.number,
                  controller: controller.audioController,
                  hintText: "Audio Rate/hour",
                  labelText: "Audio Rate/hour",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  keyboardType: TextInputType.number,
                  controller: controller.videoController,
                  hintText: "Video Rate/hour",
                  labelText: "Video Rate/hour",
                ),
                CommonWidgets.commonTextFieldForLoginSignUP(
                  controller: controller.socialUrlController,
                  hintText: "Enter Social Media Url (in any)",
                  labelText: "Enter Social Media Url (in any)",
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  chooseGender(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Color(0xffF7F8F8), borderRadius: BorderRadius.circular(20)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none, // Leading icon
            ),
            value: controller.selectedGender,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text(
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
                  style: TextStyle(
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
              print("selected gender is...$controller.selectedGender");
            },
          ),
        ),
      ),
    );
  }

  showSpecializationList(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(20)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              border: InputBorder.none, // Leading icon
            ),
            value: controller.selectedSpacialization,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: const Text(
              'Profession',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            isExpanded: true,
            items: controller.categoryList.map((GetCategoryResult items) {
              return DropdownMenuItem(
                value: items,
                child: Text(
                  items.categoryName!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
                onTap: () {},
              );
            }).toList(),
            onChanged: (newValue) {
              controller.selectedSpacialization = newValue;
              controller.increment();
            },
          ),
        ),
      ),
    );
  }
}
