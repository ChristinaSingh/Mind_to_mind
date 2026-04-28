import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/time_picker_view.dart';
import '../../../data/apis/api_models/get_category_model.dart';
import '../controllers/provider_my_profile_controller.dart';

class ProviderMyProfileView extends GetView<ProviderMyProfileController> {
  const ProviderMyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(() {
      controller.count.value;
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: CommonWidgets.appBar(title: 'My Profile'),
        bottomNavigationBar: _buildBottomButtons(context, width, height),
        body: AbsorbPointer(
          absorbing:
              controller.isLoading.value || controller.isNavigating.value,
          child: _buildBody(context, width, height),
        ),
      );
    });
  }

  Widget _buildBottomButtons(
      BuildContext context, double width, double height) {
    return Obx(() {
      // Show loading indicator while categories are loading
      if (controller.categoryList.isEmpty && controller.isInitializing.value) {
        return Container(
          height: 80,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        );
      }

      // Hide buttons if categories failed to load
      if (controller.categoryList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonWidgets.commonElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.value ||
                        controller.isNavigating.value) {
                      return;
                    } else {
                      controller.updateProfile();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Update Profile',
                        style: MyTextStyle.titleStyle16bw,
                      ),
                    ],
                  ),
                  showLoading: controller.isLoading.value,
                ),
                const SizedBox(height: 12),
                CommonWidgets.commonElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.value ||
                        controller.isNavigating.value) {
                      return;
                    } else {
                      controller.updateTime();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isNavigating.value) ...[
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(
                        Icons.schedule,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Update Time Slots',
                        style: MyTextStyle.titleStyle16bw,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, double width, double height) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.px),
          _buildProfileImage(),
          SizedBox(height: 30.px),
          _buildAccountTypeField(),
          _buildNameField(),
          _buildEmailField(),
          _buildPhoneField(),
          _buildAboutField(),
          SizedBox(height: 16.px),
          _buildSectionTitle('Specialisation'),
          SizedBox(height: 8.px),
          _buildSpecializationDropdown(context),
          SizedBox(height: 16.px),
          _buildExperienceField(),
          SizedBox(height: 16.px),
          _buildSectionTitle('Profession Location'),
          SizedBox(height: 8.px),
          _buildLocationPicker(context, width),
          SizedBox(height: 16.px),
          _buildLanguageField(),
          _buildCurrentPositionField(),
          _buildDOBField(context),
          SizedBox(height: 16.px),
          _buildSectionTitle('Gender'),
          SizedBox(height: 8.px),
          _buildGenderDropdown(context),
          SizedBox(height: 16.px),
          _buildSectionTitle('Rates (per hour)'),
          SizedBox(height: 8.px),
          _buildMessageRateField(),
          _buildAudioRateField(),
          _buildVideoRateField(),
          _buildSocialUrlField(),
          SizedBox(height: 100.px), // Extra space for bottom buttons
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 3.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: controller.profileImg == null
                ? ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(50.px),
                    child: CachedNetworkImage(
                      imageUrl: controller.profileUrl.isNotEmpty
                          ? controller.profileUrl
                          : "https://via.placeholder.com/200",
                      fit: BoxFit.cover,
                      height: 100.px,
                      width: 100.px,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50.px),
                    child: Image.file(
                      controller.profileImg!,
                      fit: BoxFit.cover,
                      height: 100.px,
                      width: 100.px,
                    ),
                  ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => controller.showAlertDialog(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  Widget _buildAccountTypeField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.accountTypeController,
      hintText: 'Account Type',
      labelText: 'Account Type',
      readOnly: true,
      prefixIcon: const Icon(Icons.account_circle, color: primaryColor),
    );
  }

  Widget _buildNameField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.nameController,
      hintText: 'Full Name',
      labelText: 'Full Name',
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      prefixIcon: const Icon(Icons.person_outline, color: primaryColor),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
    );
  }

  Widget _buildEmailField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.emailController,
      hintText: 'Email Address',
      labelText: 'Email Address',
      readOnly: true,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
    );
  }

  Widget _buildPhoneField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.phoneController,
      hintText: 'Mobile Number',
      labelText: 'Mobile Number',
      readOnly: true,
      keyboardType: TextInputType.phone,
      prefixIcon: const Icon(Icons.phone_outlined, color: primaryColor),
    );
  }

  Widget _buildAboutField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.aboutController,
      hintText: 'Tell us about yourself...',
      labelText: 'About',
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      prefixIcon: const Icon(Icons.info_outline, color: primaryColor),
      inputFormatters: [
        LengthLimitingTextInputFormatter(500),
      ],
    );
  }

  Widget _buildExperienceField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.experienceController,
      hintText: 'Years of Experience',
      labelText: 'Experience',
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.work_outline, color: primaryColor),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
    );
  }

  Widget _buildLanguageField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.languageController,
      hintText: 'e.g., English, Hindi, Arabic',
      labelText: 'Languages Known',
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      prefixIcon: const Icon(Icons.language, color: primaryColor),
    );
  }

  Widget _buildCurrentPositionField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.currPosController,
      hintText: 'Current Position/Designation',
      labelText: 'Current Position',
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      prefixIcon: const Icon(Icons.badge_outlined, color: primaryColor),
    );
  }

  Widget _buildDOBField(BuildContext context) {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      readOnly: true,
      controller: controller.dobController,
      hintText: "Select Date of Birth",
      labelText: "Date of Birth",
      prefixIcon: const Icon(Icons.cake_outlined, color: primaryColor),
      suffixIcon: GestureDetector(
        onTap: () async {
          DateTime? dateTime = await DatePickerView().datePickerView(
            context: context,
            color: primaryColor,
            lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
            initialDate:
                DateTime.now().subtract(const Duration(days: 365 * 25)),
            firstDate: DateTime(1940),
          );
          if (dateTime != null) {
            controller.dobController.text =
                DateFormat('dd/MM/yyyy').format(dateTime);
          }
        },
        child: Icon(
          Icons.calendar_today,
          size: 20.px,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildMessageRateField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.msgRateController,
      hintText: 'Enter rate (e.g., 50)',
      labelText: 'Message Rate/hour',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: const Icon(Icons.message_outlined, color: primaryColor),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  Widget _buildAudioRateField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.audioRateController,
      hintText: 'Enter rate (e.g., 100)',
      labelText: 'Audio Call Rate/hour',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: const Icon(Icons.call_outlined, color: primaryColor),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  Widget _buildVideoRateField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.videoRateController,
      hintText: 'Enter rate (e.g., 150)',
      labelText: 'Video Call Rate/hour',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: const Icon(Icons.videocam_outlined, color: primaryColor),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  Widget _buildSocialUrlField() {
    return CommonWidgets.commonTextFieldForLoginSignUP(
      controller: controller.socialUrlController,
      hintText: 'https://example.com/profile',
      labelText: 'Social Media URL (Optional)',
      keyboardType: TextInputType.url,
      prefixIcon: const Icon(Icons.link, color: primaryColor),
    );
  }

  Widget _buildGenderDropdown(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person_outline, color: primaryColor),
          ),
          value: controller.selectedGender,
          icon: const Icon(Icons.keyboard_arrow_down, color: primaryColor),
          hint: const Text(
            'Select Gender',
            style: TextStyle(
              color: hintColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          isExpanded: true,
          items: controller.genderList.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              controller.selectedGender = newValue;
              controller.increment();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSpecializationDropdown(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<GetCategoryResult>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.category_outlined, color: primaryColor),
          ),
          value: controller.selectedProfession,
          icon: const Icon(Icons.keyboard_arrow_down, color: primaryColor),
          hint:
              controller.categoryList.isEmpty && controller.isInitializing.value
                  ? Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    )
                  : const Text(
                      'Select Specialisation',
                      style: TextStyle(
                        color: hintColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
          isExpanded: true,
          items: controller.categoryList.map((GetCategoryResult item) {
            return DropdownMenuItem<GetCategoryResult>(
              value: item,
              child: Text(
                item.categoryName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              controller.selectedProfession = newValue;
              controller.increment();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLocationPicker(BuildContext context, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(Icons.location_on_outlined, color: primaryColor),
          ),
          Expanded(
            child: CountryCodePicker(
              onChanged: (CountryCode? countryCode) {
                controller.profLocController.text = countryCode?.name ?? "";
                print(
                    "Selected location: ${controller.profLocController.text}");
              },
              initialSelection: controller.profLocController.text.isNotEmpty
                  ? controller.profLocController.text
                  : 'US',
              padding: EdgeInsets.zero,
              showCountryOnly: true,
              showOnlyCountryWhenClosed: true,
              alignLeft: true,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              dialogTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
