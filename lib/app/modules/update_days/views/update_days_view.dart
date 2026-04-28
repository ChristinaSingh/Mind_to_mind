import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/update_days_controller.dart';

class UpdateDaysView extends GetView<UpdateDaysController> {
  const UpdateDaysView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(() {
      controller.count.value;
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: CommonWidgets.appBar(title: 'Update Time'),
        bottomNavigationBar: controller.isLoading.value
            ? const SizedBox()
            : Container(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: CommonWidgets.commonElevatedButton(
                onPressed: () {
                  if (controller.isAnyDayEnabled()) {
                    controller.clickOnUpdate(context);
                  } else {
                    CommonWidgets.showMyToastMessage(
                      "Please select at least one day",
                    );
                  }
                },
                child: Text(
                  "Update Schedule",
                  style: MyTextStyle.titleStyle18bw,
                ),
                showLoading: controller.isUpdate.value,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          } else {
            return _buildDaysList(context);
          }
        }),
      );
    });
  }

  Widget _buildDaysList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: controller.workingHours.length,
      itemBuilder: (BuildContext context, int index) {
        String day = controller.workingHours.keys.elementAt(index);
        bool isDayOpen = controller.dayOpened[day] ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildDayCard(context, day, isDayOpen, index),
        );
      },
    );
  }

  Widget _buildDayCard(
      BuildContext context,
      String day,
      bool isDayOpen,
      int index,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDayOpen ? primaryColor : primaryColor.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: (isDayOpen ? primaryColor : Colors.grey).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDayHeader(context, day, isDayOpen),
          if (isDayOpen) ...[
            _buildTimeSelector(context, day, isDayOpen),
            _buildSlotsList(index, isDayOpen),
          ],
        ],
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, String day, bool isDayOpen) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDayOpen
                      ? Colors.white.withOpacity(0.2)
                      : primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: isDayOpen ? Colors.white : primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                day,
                style: TextStyle(
                  color: isDayOpen ? Colors.white : primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          FlutterSwitch(
            activeText: " ",
            inactiveText: " ",
            activeColor: Colors.green,
            inactiveColor: const Color(0xffD5DDE0),
            toggleColor: Colors.white,
            value: isDayOpen,
            valueFontSize: 15.0,
            toggleSize: 22,
            width: 50,
            height: 28,
            borderRadius: 20.0,
            showOnOff: true,
            onToggle: (val) async {
              controller.dayOpened[day] = val;
              if (val) {
                controller.getMentorSlots(context, day, "toggle");
              }
              controller.increment();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context, String day, bool isDayOpen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeButton(
              context: context,
              label: 'Start Time',
              time: controller.workingHours[day]!['Open']!.format(context),
              icon: Icons.schedule,
              isDayOpen: isDayOpen,
              onTap: () {
                if (isDayOpen) {
                  controller.showMyTimePicker(context, day, 'Open', 'actual');
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTimeButton(
              context: context,
              label: 'End Time',
              time: controller.workingHours[day]!['Close']!.format(context),
              icon: Icons.access_time,
              isDayOpen: isDayOpen,
              onTap: () {
                if (isDayOpen) {
                  controller.showMyTimePicker(context, day, 'Close', 'actual');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton({
    required BuildContext context,
    required String label,
    required String time,
    required IconData icon,
    required bool isDayOpen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDayOpen
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDayOpen ? Colors.white.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isDayOpen ? Colors.white.withOpacity(0.9) : primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isDayOpen ? Colors.white.withOpacity(0.9) : primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: isDayOpen ? Colors.white : primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotsList(int index, bool isDayOpen) {
    final slots = controller.getSlotIndexData(index);

    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'No slots available',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Slots',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: slots.map((slot) {
              final isAvailable = slot.availableSlot == 'Yes';
              return InkWell(
                onTap: () {
                  slot.availableSlot = isAvailable ? 'No' : 'Yes';
                  controller.increment();
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? Colors.green
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isAvailable
                          ? Colors.green.shade700
                          : Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.circle_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        slot.time ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildShimmerCard(),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _shimmerBox(width: 40, height: 40, radius: 8),
                      const SizedBox(width: 12),
                      _shimmerBox(width: 100, height: 20),
                    ],
                  ),
                  _shimmerBox(
                    width: 50,
                    height: 28,
                    radius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _shimmerBox(height: 60, radius: 12),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _shimmerBox(height: 60, radius: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerBox(width: 120, height: 14),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  6,
                      (index) => _shimmerBox(
                    width: 80,
                    height: 32,
                    radius: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double? height,
    double? width,
    double radius = 8,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}