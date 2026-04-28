import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/all_mentor_list_controller.dart';

class AllMentorListView extends GetView<AllMentorListController> {
  const AllMentorListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonWidgets.appBar(
          title: '${controller.parameters[ApiKeyConstants.title]}'),
      body: Obx(() {
        controller.count.value;
        return Column(
          children: [
            // Enhanced Search Bar Section
            Container(
              padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 8.px),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your Perfect Mentor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryDarkColor,
                    ),
                  ),
                  SizedBox(height: 12.px),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.px),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.05),
                          primaryColor.withOpacity(0.02),
                        ],
                      ),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Search mentors by name or category...',
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: primaryColor,
                          size: 22.px,
                        ),
                        suffixIcon: controller.searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: hintColor,
                            size: 20.px,
                          ),
                          onPressed: () {
                            controller.searchController.clear();
                            if (controller.parameters[ApiKeyConstants.type] == "All") {
                              controller.getMentorList();
                            } else if (controller.parameters[ApiKeyConstants.type] == ApiKeyConstants.categoryId) {
                              controller.getMentorListByCategory(
                                  controller.parameters[ApiKeyConstants.categoryId] ?? '');
                            }
                            controller.increment();
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.px,
                          vertical: 14.px,
                        ),
                      ),
                      onChanged: (value) {
                        controller.searchMentor();
                        controller.increment();
                      },
                    ),
                  ),
                  SizedBox(height: 8.px),
                ],
              ),
            ),

            // Mentor List Section
            Expanded(
              child: controller.isLoading.value
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16.px),
                    Text(
                      'Loading mentors...',
                      style: TextStyle(
                        color: hintColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
                  : controller.mentorList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64.px,
                      color: hintColor.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.px),
                    Text(
                      'No mentors found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
                    SizedBox(height: 8.px),
                    Text(
                      'Try adjusting your search',
                      style: TextStyle(
                        fontSize: 13,
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.px,
                  vertical: 12.px,
                ),
                itemCount: controller.mentorList.length,
                itemBuilder: (context, index) {
                  final mentor = controller.mentorList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.px),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.px),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: primaryColor.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.px),
                        onTap: () {
                          controller.clickOnMentor(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(14.px),
                          child: Row(
                            children: [
                              // Profile Image with Gradient Border
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor,
                                      primaryColor.withOpacity(0.6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(3.px),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(2.px),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.px),
                                    child: CachedNetworkImage(
                                      imageUrl: mentor.image ??
                                          "https://picsum.photos/200/300",
                                      fit: BoxFit.cover,
                                      height: 58.px,
                                      width: 58.px,
                                      placeholder: (context, url) => Container(
                                        color: primaryColor.withOpacity(0.1),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: primaryColor.withOpacity(0.1),
                                        child: Icon(
                                          Icons.person,
                                          color: primaryColor,
                                          size: 30.px,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.px),

                              // Mentor Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mentor.name ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryDarkColor,
                                        letterSpacing: 0.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.px),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.px,
                                        vertical: 3.px,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6.px),
                                      ),
                                      child: Text(
                                        mentor.categoryName ?? '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6.px),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.psychology_outlined,
                                          size: 14.px,
                                          color: labelColor,
                                        ),
                                        SizedBox(width: 4.px),
                                        Text(
                                          "MENTAL HEALTH",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: labelColor,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Right Side - Price and Favorite
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6.px),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 18.px,
                                    ),
                                  ),
                                  SizedBox(height: 8.px),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.px,
                                      vertical: 6.px,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor,
                                          primaryColor.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8.px),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "\$${mentor.audioRate}/hr",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}