import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/get_mentor_detail_model.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/mentor_details_controller.dart';

class MentorDetailsView extends GetView<MentorDetailsController> {
  const MentorDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(() {
      controller.count.value;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: CommonWidgets.appBar(
          title: controller.parameter[ApiKeyConstants.type] ?? 'Mentor Details',
        ),
        bottomNavigationBar: controller.isLoading.value
            ? const SizedBox()
            : controller.mentorDetail == null
            ? const SizedBox()
            : Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: CommonWidgets.commonElevatedButton(
            onPressed: () {
              controller.clickOnRequestMentor();
            },
            child: Text(
              'Book Appointment',
              style: MyTextStyle.titleStyle16bw,
            ),
          ),
        ),
        body: controller.isLoading.value
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading mentor details...',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
            : controller.mentorDetail == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: hintColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load mentor details',
                style: TextStyle(
                  fontSize: 16,
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => controller.getMentorDetails(),
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            await controller.getMentorDetails();
          },
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.px),

                  // Profile Card
                  _buildProfileCard(width, height),

                  SizedBox(height: 30.px),

                  // Stats Section
                  _buildStatsSection(controller.mentorDetail!),

                  SizedBox(height: 30.px),

                  // About Section
                  _buildAboutSection(),

                  SizedBox(height: 25.px),

                  // Social Media Section
                  if (controller.mentorDetail!.socialMediaUrl != null &&
                      controller.mentorDetail!.socialMediaUrl!.isNotEmpty)
                    _buildSocialMediaSection(),

                  if (controller.mentorDetail!.socialMediaUrl != null &&
                      controller.mentorDetail!.socialMediaUrl!.isNotEmpty)
                    SizedBox(height: 25.px),

                  // Availability Section
                  _buildAvailabilitySection(),

                  SizedBox(height: 30.px),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileCard(double width, double height) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Row(
          children: [
            // Profile Image
            Hero(
              tag: 'mentor_${controller.parameter[ApiKeyConstants.mentorId]}',
              child: Container(
                width: width * 0.25,
                height: width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: controller.mentorDetail!.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: hintColor.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: hintColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: hintColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 16.px),

            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          controller.mentorDetail!.name ?? 'Unknown',
                          style: MyTextStyle.titleStyle16bb,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Obx(() {
                        controller.count.value;
                        return InkWell(
                          onTap: controller.isBtnLoading.value
                              ? null
                              : () => controller.addToFavorite(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: controller.mentorDetail!.favoriteStatus == "like"
                                  ? Colors.red.withOpacity(0.1)
                                  : hintColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: controller.isBtnLoading.value
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            )
                                : Icon(
                              controller.mentorDetail!.favoriteStatus == "like"
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.mentorDetail!.favoriteStatus == "like"
                                  ? Colors.red
                                  : hintColor,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 8.px),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.mentorDetail!.categoryName ?? '',
                      style: TextStyle(
                        color: primaryDarkColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.px),

                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 14,
                        color: labelColor,
                      ),
                      SizedBox(width: 6.px),
                      Expanded(
                        child: Text(
                          controller.mentorDetail!.currentPosition ?? '',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(MentorDetailResult mentorDetailResult) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: "assets/images/PeopleIcon.svg",
            value: "${controller.mentorDetail!.profession ?? '0'}+",
            label: "Mentor Sessions",
          ),
        ),
        SizedBox(width: 16.px),
        Expanded(
          child: _buildStatCard(
            icon: "assets/images/ExpirenceIcon.svg",
            value: "${controller.mentorDetail!.exp ?? '0'}+",
            label: "Years Experience",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.px),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              height: 40,
              color: primaryColor,
            ),
            SizedBox(height: 12.px),
            Text(
              value,
              style: TextStyle(
                color: primaryDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.px),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Me",
          style: MyTextStyle.titleStyle18bb,
        ),
        SizedBox(height: 12.px),
        Card(
          elevation: 0,
          color: hintColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: outlineInputBorderDayColor.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.px),
            child: Text(
              controller.mentorDetail!.about ?? 'No information available',
              style: TextStyle(
                color: labelColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Social Media",
          style: MyTextStyle.titleStyle18bb,
        ),
        SizedBox(height: 12.px),
        InkWell(
          onTap: () {
            // TODO: Implement URL launcher
            CommonWidgets.snackBarView(title: 'Work in progress');
          },
          child: Card(
            elevation: 0,
            color: primaryColor.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: primaryColor.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.px),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 12.px),
                  Expanded(
                    child: Text(
                      controller.mentorDetail!.socialMediaUrl ?? "",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    color: primaryColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    if (controller.mentorDetail?.mentorTime == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Availability",
            style: MyTextStyle.titleStyle18bb,
          ),
          SizedBox(height: 12.px),
          Card(
            elevation: 0,
            color: hintColor.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.px),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 40,
                      color: hintColor,
                    ),
                    SizedBox(height: 12.px),
                    Text(
                      "No availability schedule found",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    final mentorTime = controller.mentorDetail!.mentorTime!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Availability",
          style: MyTextStyle.titleStyle18bb,
        ),
        SizedBox(height: 12.px),
        Card(
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.px),
            child: Column(
              children: [
                _buildAvailabilityRow("Monday", mentorTime.mondayStartTime, mentorTime.mondayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Tuesday", mentorTime.tuesdayStartTime, mentorTime.tuesdayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Wednesday", mentorTime.wednesdayStartTime, mentorTime.wednesdayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Thursday", mentorTime.thursdayStartTime, mentorTime.thursdayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Friday", mentorTime.fridayStartTime, mentorTime.fridayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Saturday", mentorTime.saturdayStartTime, mentorTime.saturdayCloseTime),
                _buildDivider(),
                _buildAvailabilityRow("Sunday", mentorTime.sundayStartTime, mentorTime.sundayCloseTime),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(String day, String? startTime, String? closeTime) {
    final isClosed = closeTime == "Closed" || startTime == "Closed";
    final timeText = isClosed
        ? "Closed"
        : "$startTime - $closeTime";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
            decoration: BoxDecoration(
              color: isClosed
                  ? hintColor.withOpacity(0.1)
                  : primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              timeText,
              style: TextStyle(
                color: isClosed ? hintColor : primaryDarkColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: outlineInputBorderDayColor.withOpacity(0.2),
      height: 1,
    );
  }
}