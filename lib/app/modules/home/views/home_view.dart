import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/local_data.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/constants/string_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        controller.count.value;
        return controller.isLoading.value
            ? _buildShimmerLoading(context, width, height)
            : CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildBannerSection(context, width, height),
                        _buildCategoriesSection(context, width, height),
                        _buildMentorsSection(context, width, height),
                        SizedBox(height: 20),
                        Column(
                          children: controller.mentorListByCategory.entries
                              .map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        InkWell(
                                          onTap: () => controller.clickOnSeeAll(
                                              entry.key, entry.key),
                                          borderRadius:
                                              BorderRadius.circular(20.px),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.px,
                                                vertical: 6.px),
                                            decoration: BoxDecoration(
                                              color:
                                                  primaryColor.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20.px),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "See All",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                SizedBox(width: 4.px),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 12.px,
                                                  color: primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 220,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: entry.value.length,
                                    itemBuilder: (context, index) {
                                      final mentor = entry.value[index];
                                      return GestureDetector(
                                        onTap: () =>
                                            controller.clickOnMentor(index),
                                        child: Container(
                                          width: 170.px,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.px, vertical: 5.px),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.px),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withOpacity(0.15),
                                                blurRadius: 15,
                                                offset: Offset(0, 8),
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 140.px,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                20.px),
                                                        topRight:
                                                            Radius.circular(
                                                                20.px),
                                                      ),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          primaryColor
                                                              .withOpacity(0.1),
                                                          Colors.white,
                                                        ],
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        width: 90.px,
                                                        height: 90.px,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 4.px,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 12,
                                                              offset:
                                                                  Offset(0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      45.px),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: controller
                                                                .mentorList[
                                                                    index]
                                                                .image!,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      primaryColor,
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Icon(
                                                                Icons.person,
                                                                color:
                                                                    primaryColor,
                                                                size: 40.px,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 10.px,
                                                    right: 10.px,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // Favorite action
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            6.px),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          controller
                                                                      .mentorList[
                                                                          index]
                                                                      .favoriteStatus ==
                                                                  "unlike"
                                                              ? Icons
                                                                  .favorite_border
                                                              : Icons.favorite,
                                                          color: controller
                                                                      .mentorList[
                                                                          index]
                                                                      .favoriteStatus ==
                                                                  "unlike"
                                                              ? hintColor
                                                              : Colors.red,
                                                          size: 18.px,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.px,
                                                      vertical: 10.px),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        controller
                                                                .mentorList[
                                                                    index]
                                                                .name ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 4.px),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.px,
                                                          vertical: 4.px,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.px),
                                                        ),
                                                        child: Text(
                                                          controller
                                                                  .mentorList[
                                                                      index]
                                                                  .categoryName ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: primaryColor,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ); // your card widget
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 150.px),
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 90.px,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 1,
      surfaceTintColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.px, 50.px, 20.px, 10.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Find Your Next",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: labelColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                "Mentor Here",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (LocalData.userType == 'Both')
          Container(
            margin: EdgeInsets.only(right: 15.px),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.showAlertDialog(context),
                borderRadius: BorderRadius.circular(25.px),
                child: Container(
                  padding: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.px),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_both.svg",
                    height: 24.px,
                    width: 24.px,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBannerSection(
      BuildContext context, double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.px),
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: height * 0.20,
              aspectRatio: 16 / 9,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOutCubic,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
              enableInfiniteScroll: controller.bannerList.length > 1,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              onPageChanged: (index, reason) {
                controller.activeIndex = index;
                controller.increment();
              },
            ),
            itemCount: controller.bannerList.length,
            itemBuilder: (context, int index, int realIndex) {
              return Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.px),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: controller.bannerList[index].image,
                      fit: BoxFit.cover,
                      width: width,
                      height: height * 0.22,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: primaryColor.withOpacity(0.2),
                        highlightColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.px),
                            color: primaryColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 15.px),
          _buildCarouselIndicators(),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.bannerList.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.px),
          height: 8.px,
          width: controller.activeIndex == index ? 24.px : 8.px,
          decoration: BoxDecoration(
            color: controller.activeIndex == index
                ? primaryColor
                : primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.px),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
      BuildContext context, double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Text(
              "Medical Specialties",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 15.px),
          SizedBox(
            height: 120.px,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15.px),
              itemCount: controller.categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                final categoryName =
                    controller.categoryList[index].categoryName!.toLowerCase();

                final isSelected = controller.selectedCategory?.categoryName ==
                    controller.categoryList[index].categoryName;

                return GestureDetector(
                  onTap: () {
                    controller.selectedCategory =
                        controller.categoryList[index];
                    controller.getMentorListByCategory(
                        controller.categoryList[index].id!);
                    controller.clickOnCategoryItem(index);
                  },
                  child: IntrinsicWidth(
                    // ✅ auto width based on content
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5.px),
                      padding: EdgeInsets.symmetric(horizontal: 10.px),
                      // ✅ add padding
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16.px),
                        border: Border.all(
                          color:
                              isSelected ? primaryColor : Colors.grey.shade200,
                          width: isSelected ? 2.px : 1.px,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? primaryColor.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                            blurRadius: isSelected ? 12 : 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ✅ Logo
                          Container( width: 50.px, height: 50.px, decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(27.5.px), border: Border.all( color: isSelected ? primaryColor : Colors.grey.shade300, width: 2.px, ), boxShadow: [ BoxShadow( color: primaryColor.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2), ), ], ), clipBehavior: Clip.hardEdge, child: CommonWidgets.imageView( image: controller.categoryList[index].image!, height: 50, width:50, fit: BoxFit.fill, borderRadius: 50 / 2, defaultNetworkImage: StringConstants.defaultNetworkImage), ),

                          SizedBox(height: 8.px),

                          // ✅ Text (Same size, full visible)
                          Text(
                            categoryName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10, // ✅ fixed size
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? primaryColor : labelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMentorsSection(
      BuildContext context, double width, double height) {
    return Container(
      margin: EdgeInsets.only(top: 20.px),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Professionals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      "Top-rated healthcare experts",
                      style: TextStyle(
                        fontSize: 13,
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => controller.clickOnSeeAll("All", "All Category"),
                  borderRadius: BorderRadius.circular(20.px),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(width: 4.px),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.px,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.px),
          SizedBox(
            height: 240.px,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15.px),
              itemCount: controller.mentorList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => controller.clickOnMentor(index),
                  child: Container(
                    width: 170.px,
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.px, vertical: 5.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.px),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.15),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 140.px,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.px),
                                  topRight: Radius.circular(20.px),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    primaryColor.withOpacity(0.1),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 90.px,
                                  height: 90.px,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4.px,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45.px),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          controller.mentorList[index].image!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: primaryColor.withOpacity(0.1),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: primaryColor.withOpacity(0.1),
                                        child: Icon(
                                          Icons.person,
                                          color: primaryColor,
                                          size: 40.px,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.px,
                              right: 10.px,
                              child: GestureDetector(
                                onTap: () {
                                  // Favorite action
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6.px),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    controller.mentorList[index]
                                                .favoriteStatus ==
                                            "unlike"
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: controller.mentorList[index]
                                                .favoriteStatus ==
                                            "unlike"
                                        ? hintColor
                                        : Colors.red,
                                    size: 18.px,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.px, vertical: 10.px),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.mentorList[index].name ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.px),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.px,
                                    vertical: 4.px,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.px),
                                  ),
                                  child: Text(
                                    controller.mentorList[index].categoryName ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(
      BuildContext context, double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 120.px),
            Container(
              height: height * 0.22,
              margin: EdgeInsets.symmetric(horizontal: 20.px, vertical: 20.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.px),
              ),
            ),
            SizedBox(
              height: 120.px,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.px),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 90.px,
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.px),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.px),
            SizedBox(
              height: 240.px,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.px),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 170.px,
                    margin: EdgeInsets.symmetric(horizontal: 5.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
