import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/text_styles.dart';
import '../controllers/mentor_appointment_details_controller.dart';

class MentorAppointmentDetailsView
    extends GetView<MentorAppointmentDetailsController> {
  const MentorAppointmentDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(body: Obx(() {
      controller.count.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: height * 0.3,
                width: width,
                child: CachedNetworkImage(
                  imageUrl: controller.appointmentData.userDetails!.image ??
                      "https://picsum.photos/200/300",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 30),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              SvgPicture.asset("assets/images/backButton.svg"),
                        )),
                    SizedBox(
                      width: width * 0.7,
                      child: Center(
                        child: Text(
                          'Appointment Details',
                          style: MyTextStyle.titleStyle18bw,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.appointmentData.userDetails?.name ?? "",
                  style: MyTextStyle.titleStyle16bb,
                ),
                SizedBox(
                  height: 5.px,
                ),
                Text(
                  'Appointment Date - ${controller.appointmentData.appointmentDate}',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  'Appointment Time - ${controller.appointmentData.time}',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'DOB',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.dob ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'Gender',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.gender ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'Gender',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.gender ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'Email',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.email ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'Mobile number',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.mobile ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Text(
                  'About',
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 2.px,
                ),
                Text(
                  controller.appointmentData.userDetails?.about ?? "Not found",
                  style: MyTextStyle.titleStyle14bb,
                ),
                SizedBox(
                  height: 10.px,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      controller.appointmentData.packageId == "Messaging"
                          ? 'assets/images/MessagingIcon.svg'
                          : controller.appointmentData.packageId == 'Voice call'
                              ? 'assets/images/voiceCallIcon.svg'
                              : controller.appointmentData.packageId ==
                                      'Video call'
                                  ? 'assets/images/videoCallIcon.svg'
                                  : '',
                    ),
                    SizedBox(
                      width: 10.px,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.appointmentData.packageId == "Messaging"
                              ? 'Messaging'
                              : controller.appointmentData.packageId ==
                                      'Voice call'
                                  ? 'Voice call'
                                  : controller.appointmentData.packageId ==
                                          'Video call'
                                      ? 'Video call'
                                      : '',
                          style: MyTextStyle.titleStyle18bb,
                        ),
                        SizedBox(
                          height: 5.px,
                        ),
                        Text(
                          controller.appointmentData.packageId == "Messaging"
                              ? 'Chat message with Mentor'
                              : controller.appointmentData.packageId ==
                                      'Voice call'
                                  ? 'Voice call with Mentor'
                                  : controller.appointmentData.packageId ==
                                          'Video call'
                                      ? 'Video call with Mentor'
                                      : '',
                          style: MyTextStyle.titleStyle16bb,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    }));
    //   Scaffold(
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Stack(
    //         children: [
    //           Container(
    //             height: height * 0.3,
    //             width: width,
    //             child: CachedNetworkImage(
    //               imageUrl: controller.appointmentData.userDetails!.image ??
    //                   "https://picsum.photos/200/300",
    //               fit: BoxFit.cover,
    //               placeholder: (context, url) => const Center(
    //                   child: CircularProgressIndicator(
    //                 color: primaryColor,
    //               )),
    //               errorWidget: (context, url, error) => const Icon(Icons.error),
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 30),
    //             child: Row(
    //               children: [
    //                 InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child:
    //                           SvgPicture.asset("assets/images/backButton.svg"),
    //                     )),
    //                 SizedBox(
    //                   width: width * 0.7,
    //                   child: Center(
    //                     child: Text(
    //                       'Appointment Details',
    //                       style: MyTextStyle.titleStyle18bw,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               controller.appointmentData.userDetails?.name ?? "",
    //               style: MyTextStyle.titleStyle16bb,
    //             ),
    //             SizedBox(
    //               height: 5.px,
    //             ),
    //             Text(
    //               'Appointment Date - ${controller.appointmentData.appointmentDate}',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               'Appointment Time - ${controller.appointmentData.time}',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'DOB',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.dob ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'Gender',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.gender ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'Gender',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.gender ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'Email',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.email ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'Mobile number',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.mobile ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Text(
    //               'Problem',
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 2.px,
    //             ),
    //             Text(
    //               controller.appointmentData.userDetails?.about ?? "Not found",
    //               style: MyTextStyle.titleStyle14bb,
    //             ),
    //             SizedBox(
    //               height: 10.px,
    //             ),
    //             Row(
    //               children: [
    //                 SvgPicture.asset(
    //                   controller.appointmentData.packageId == "Messaging"
    //                       ? 'assets/images/MessagingIcon.svg'
    //                       : controller.appointmentData.packageId == 'Voice call'
    //                           ? 'assets/images/voiceCallIcon.svg'
    //                           : controller.appointmentData.packageId ==
    //                                   'Video call'
    //                               ? 'assets/images/videoCallIcon.svg'
    //                               : '',
    //                 ),
    //                 SizedBox(
    //                   width: 10.px,
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       controller.appointmentData.packageId == "Messaging"
    //                           ? 'Messaging'
    //                           : controller.appointmentData.packageId ==
    //                                   'Voice call'
    //                               ? 'Voice call'
    //                               : controller.appointmentData.packageId ==
    //                                       'Video call'
    //                                   ? 'Video call'
    //                                   : '',
    //                       style: MyTextStyle.titleStyle18bb,
    //                     ),
    //                     SizedBox(
    //                       height: 5.px,
    //                     ),
    //                     Text(
    //                       controller.appointmentData.packageId == "Messaging"
    //                           ? 'Chat message with doctor'
    //                           : controller.appointmentData.packageId ==
    //                                   'Voice call'
    //                               ? 'Voice call with doctor'
    //                               : controller.appointmentData.packageId ==
    //                                       'Video call'
    //                                   ? 'Video call with doctor'
    //                                   : '',
    //                       style: MyTextStyle.titleStyle16bb,
    //                     )
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
