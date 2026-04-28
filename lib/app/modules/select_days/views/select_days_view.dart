import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/select_days_controller.dart';

class SelectDaysView extends GetView<SelectDaysController> {
  const SelectDaysView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Obx(() {
      controller.count.value;
      return Scaffold(
        appBar: CommonWidgets.appBar(title: 'Add Time'),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 30),
            child: CommonWidgets.commonElevatedButton(
                onPressed: () {
                  // addTime();
                  //   controller.clickOnAddTime(context);

                  controller.isAnyDayEnabled()
                      ? controller.clickOnAddTime(context)
                      : CommonWidgets.showMyToastMessage("please select slots");
                  ;
                },
                child: Text(
                  "Next",
                  style: MyTextStyle.titleStyle18bw,
                ),
                showLoading: controller.isLoading.value)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView.builder(
            itemCount: controller.workingHours.length,
            itemBuilder: (BuildContext context, int index) {
              String day = controller.workingHours.keys.elementAt(index);
              String dayOpen = controller.dayOpened.keys.elementAt(index);
              String breakEnable = controller.breakEnable.keys.elementAt(index);
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: controller.dayOpened[dayOpen] == true
                            ? primaryColor
                            : primaryDarkColor.withOpacity(0.9)),
                    child: Column(
                      children: [
                        ListTile(
                          //  isThreeLine: true,
                          title: Text(day,
                              style: TextStyle(
                                color: controller.dayOpened[dayOpen] == true
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 5.px),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.dayOpened[dayOpen] == true)
                                      controller.showMyTimePicker(
                                          context, day, 'Open', "actual");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5.px),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                controller.dayOpened[dayOpen] ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5))),
                                    child: Text(
                                      'Open: ${controller.workingHours[day]!['Open']!.format(context)}',
                                      style: TextStyle(
                                        color: controller.dayOpened[dayOpen] ==
                                                true
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.px),
                                GestureDetector(
                                  onTap: () {
                                    if (controller.dayOpened[dayOpen] == true)
                                      controller.showMyTimePicker(
                                          context, day, 'Close', "actual");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5.px),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                controller.dayOpened[dayOpen] ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5))),
                                    child: Text(
                                        'Close: ${controller.workingHours[day]!['Close']!.format(context)}',
                                        style: TextStyle(
                                          color: controller
                                                      .dayOpened[dayOpen] ==
                                                  true
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Column(
                            children: [
                              Container(
                                width: width * 0.1,
                                child: FlutterSwitch(
                                  activeText: " ",
                                  inactiveText: " ",
                                  // height: 40,
                                  activeColor: Colors.white,
                                  toggleColor: Colors.grey,
                                  inactiveColor: const Color(0xffD5DDE0),
                                  value: controller.dayOpened[dayOpen]!,
                                  valueFontSize: 15.0,
                                  toggleSize: 20,
                                  width: 45,
                                  height: 25,
                                  borderRadius: 20.0,
                                  showOnOff: true,
                                  onToggle: (val) async {
                                    controller.dayOpened[dayOpen] = val;
                                    controller.getMentorSlots(context, dayOpen);
                                    controller.increment();
                                    print(
                                        "status is ::::::::::::${controller.dayOpened[dayOpen]}");
                                    //await changeOnlineOfflineStatus();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        controller.dayOpened[dayOpen] == true
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Wrap(
                                    spacing: 8.0, // Space between the slots
                                    runSpacing: 8.0, // Space between the lines
                                    children: controller
                                        .getSlotIndexData(index)
                                        .map((slot) {
                                      return InkWell(
                                        onTap: () {
                                          slot.available = !slot.available!;
                                          controller.increment();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: slot.available!
                                                ? Colors.green
                                                : Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Text(
                                            slot.time ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList()),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
