import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(
            title: 'Favorites'),
        body: Obx(() {
          controller.count.value;
          controller.isLoading.value;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.px),
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.favoriteList.isEmpty
                    ? Center(
                        child: Text(
                        "No mentor added to wishlist",
                        style: MyTextStyle.titleStyle18bb,
                      ))
                    : SingleChildScrollView(
                        child: ListView.builder(
                            itemCount: controller.favoriteList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 20.px),
                                padding: EdgeInsets.all(5.px),
                                //   margin: EdgeInsets.all(10.px),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        //color of shadow
                                        spreadRadius: 2,
                                        //spread radius
                                        blurRadius: 9,
                                        // blur radius
                                        offset: Offset(0, 2), // changes position of shadow
                                        //first paramerter of offset is left-right
                                        //second parameter is top to down
                                      ),
                                    ]),
                                child: ListTile(
                                  titleAlignment:
                                      ListTileTitleAlignment.titleHeight,
                                  leading:
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
                                        borderRadius: BorderRadius.circular(100.px),
                                        child: CachedNetworkImage(
                                          imageUrl: controller.favoriteList[index].image ??
                                              "https://picsum.photos/200/300",
                                          fit: BoxFit.fill,
                                          height: 50.px,
                                          width: 50.px,
                                          placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColor,
                                              )),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                      )
                                  ),
                                  title: Text(
                                    controller.favoriteList[index].name ?? '',
                                    style: MyTextStyle.titleStyle16bb,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.favoriteList[index]
                                                .categoryName ??
                                            '',
                                        style: MyTextStyle.titleStyle14b,
                                      ),
                                      Text(
                                        "MENTAL HEALTH",
                                        style: MyTextStyle.titleStyle14b,
                                      )
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "\$ ${controller.favoriteList[index].audioRate}/hour",
                                        style: MyTextStyle.titleStyle12gr,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             MentorDetailScreen(
                                    //               mentorCategory:
                                    //               favoriteList![index]
                                    //                   .categoryName!,
                                    //               mentorId:
                                    //               favoriteList![index].id!,
                                    //             )));
                                  },
                                ),
                              );
                            })),
          );
        }));
  }
}
