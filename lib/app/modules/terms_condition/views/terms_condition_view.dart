import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';
import '../../../../common/common_widgets.dart';
import '../controllers/terms_condition_controller.dart';

class TermsConditionView extends GetView<TermsConditionController> {
  const TermsConditionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: CommonWidgets.appBar(title: 'Terms and Conditions'),
        body: Obx(() {
          controller.count.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/termsConditionImage.png",
                    height: 150,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  controller.tandConditionResult == null
                      ?  Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                      : Html(data: controller.tandConditionResult!.description)
                ],
              ),
            ),
          );
        }));
  }
}
