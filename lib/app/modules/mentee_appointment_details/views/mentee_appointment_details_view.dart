import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/common_methods.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/colors.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/mentee_appointment_details_controller.dart';

class MenteeAppointmentDetailsView
    extends GetView<MenteeAppointmentDetailsController> {
  const MenteeAppointmentDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          controller.count.value;
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: height * 0.3,
                            width: width,
                            child: CachedNetworkImage(
                              imageUrl: controller.appointmentDetailsResult
                                      ?.mentorDetails!.image ??
                                  "https://picsum.photos/200/300",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                color: primaryColor,
                              )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.px, vertical: 30),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.NAV_BAR);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          "assets/images/backButton.svg"),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.px, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.appointmentDetailsResult?.mentorDetails
                                      ?.name ??
                                  "",
                              style: MyTextStyle.titleStyle16bb,
                            ),
                            SizedBox(
                              height: 20.px,
                            ),
                            Text(
                              'Appointment Date - ${CommonMethods.formatDate(controller.appointmentDetailsResult?.appointmentDate)}',
                              style: MyTextStyle.titleStyle14bb,
                            ),
                            SizedBox(
                              height: 20.px,
                            ),
                            Text(
                              'Appointment Time - ${controller.appointmentDetailsResult?.time}',
                              style: MyTextStyle.titleStyle14bb,
                            ),
                            // SizedBox(
                            //   height: 10.px,
                            // ),
                            // Text(
                            //   'DOB',
                            //   style: MyTextStyle.titleStyle14bb,
                            // ),
                            // SizedBox(
                            //   height: 2.px,
                            // ),
                            // Text(
                            //   controller.appointmentDetailsResult?.userDetails
                            //           ?.dob ??
                            //       "Not found",
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // SizedBox(
                            //   height: 20.px,
                            // ),
                            // Text(
                            //   'Gender',
                            //   style: MyTextStyle.titleStyle14bb,
                            // ),
                            // SizedBox(
                            //   height: 2.px,
                            // ),
                            // Text(
                            //   controller.appointmentDetailsResult?.userDetails
                            //           ?.gender ??
                            //       "Not found",
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            SizedBox(
                              height: 20.px,
                            ),
                            // Text(
                            //   'Email',
                            //   style: MyTextStyle.titleStyle14bb,
                            // ),
                            // SizedBox(
                            //   height: 2.px,
                            // ),
                            // Text(
                            //   controller.appointmentDetailsResult?.userDetails
                            //           ?.email ??
                            //       "Not found",
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // SizedBox(
                            //   height: 10.px,
                            // ),
                            // Text(
                            //   'Mobile number',
                            //   style: MyTextStyle.titleStyle14bb,
                            // ),
                            // SizedBox(
                            //   height: 2.px,
                            // ),
                            // Text(
                            //   controller.appointmentDetailsResult?.userDetails
                            //           ?.mobile ??
                            //       "Not found",
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // SizedBox(
                            //   height: 10.px,
                            // ),
                            // Text(
                            //   'Problem',
                            //   style: MyTextStyle.titleStyle14bb,
                            // ),
                            // SizedBox(
                            //   height: 2.px,
                            // ),
                            // Text(
                            //   controller.appointmentDetailsResult?.userDetails
                            //           ?.about ??
                            //       "Not found",
                            //   style: TextStyle(
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            SizedBox(
                              height: 200.px,
                            ),
                            Row(
                              children: [
                                // SvgPicture.asset(
                                //   controller.appointmentDetailsResult
                                //               ?.packageId ==
                                //           "Messaging"
                                //       ? 'assets/images/MessagingIcon.svg'
                                //       : controller.appointmentDetailsResult
                                //                   ?.packageId ==
                                //               'Voice call'
                                //           ? 'assets/images/voiceCallIcon.svg'
                                //           : controller.appointmentDetailsResult
                                //                       ?.packageId ==
                                //                   'Video call'
                                //               ? 'assets/images/videoCallIcon.svg'
                                //               : '',
                                // ),
                                SizedBox(
                                  width: 10.px,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.appointmentDetailsResult
                                                  ?.packageId ==
                                              "Messaging"
                                          ? 'Messaging'
                                          : controller.appointmentDetailsResult
                                                      ?.packageId ==
                                                  'Voice call'
                                              ? 'Voice call'
                                              : controller.appointmentDetailsResult
                                                          ?.packageId ==
                                                      'Video call'
                                                  ? 'Video call'
                                                  : '',
                                      style: MyTextStyle.titleStyle18bb,
                                    ),
                                    SizedBox(
                                      height: 5.px,
                                    ),
                                    Text(
                                      controller.appointmentDetailsResult
                                                  ?.packageId ==
                                              "Messaging"
                                          ? 'Chat message with your Mentor'
                                          : controller.appointmentDetailsResult
                                                      ?.packageId ==
                                                  'Voice call'
                                              ? 'Voice call with your Mentor'
                                              : controller.appointmentDetailsResult
                                                          ?.packageId ==
                                                      'Video call'
                                                  ? 'Video call with your Mentor'
                                                  : '',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            CommonWidgets.commonElevatedButton(
                              onPressed: () {
                                Get.offAllNamed(Routes.NAV_BAR);
                              },
                              child: Text(
                                'Done',
                                style: MyTextStyle.titleStyle16bw,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }));
  }
  // Add a function to format the date


}
