import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/text_styles.dart';
import '../controllers/booking_success_controller.dart';

class BookingSuccessView extends GetView<BookingSuccessController> {
  const BookingSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(
            wantBackButton: false, title: 'Booking Success'),
        body: Obx(() {
          controller.count.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    SvgPicture.asset(
                      "assets/images/successIcon.svg",
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      'Congratulations!',
                      style: MyTextStyle.titleStyle20bb,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      'Mentoring session successfully booked. You will receive a notification email shortly conforming this booking!',
                      style: MyTextStyle.titleStyle14gr,
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    CommonWidgets.commonElevatedButton(
                      onPressed: () {
                        controller.clickOnViewAppointment();
                      },
                      child: Text(
                        'View Appointment',
                        style: MyTextStyle.titleStyle16bw,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
