import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';

import '../controllers/select_package_controller.dart';

class SelectPackageView extends GetView<SelectPackageController> {
  const SelectPackageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBar(title: 'Select Package'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Obx(() => CommonWidgets.commonElevatedButton(
          onPressed: () {
            if (!controller.isApiLoading.value) {
              controller.clickOnNext();
            }
          },
          child: controller.isApiLoading.value
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          )
              : Text('Next', style: MyTextStyle.titleStyle16bw),
        )),
      ),
      body: Obx(() {
        controller.count.value;

        if (controller.isPageLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.packageResult == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Failed to load packages'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.getPackageRate(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ✅ Booking summary card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border:
                        Border.all(color: primaryColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Summary',
                            style: MyTextStyle.titleStyleCustom(
                                14, FontWeight.w700, primaryDarkColor),
                          ),
                          const SizedBox(height: 12),
                          // Date
                          _summaryRow(
                            Icons.calendar_today_outlined,
                            'Date',
                            controller.parameter[
                            'appointment_date'] ??
                                '--',
                          ),
                          const SizedBox(height: 8),
                          // Time range
                          _summaryRow(
                            Icons.access_time_outlined,
                            'Time',
                            '${controller.startTime} → ${controller.endTime}',
                          ),
                          const SizedBox(height: 8),
                          // Duration
                          _summaryRow(
                            Icons.timelapse_outlined,
                            'Duration',
                            controller.formattedDuration,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Select Package',
                      style: MyTextStyle.titleStyleCustom(
                          18, FontWeight.w700, textGreyColor),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Package cards
                    _packageCard(
                      svgPath: 'assets/images/MessagingIcon.svg',
                      title: 'Messaging',
                      subtitle: 'Chat message with Mentor',
                      baseRate:
                      controller.packageResult!.messageRate ?? '0',
                      value: 'Messaging',
                    ),
                    const SizedBox(height: 16),
                    _packageCard(
                      svgPath: 'assets/images/voiceCallIcon.svg',
                      title: 'Voice call',
                      subtitle: 'Voice call with Mentor',
                      baseRate:
                      controller.packageResult!.audioRate ?? '0',
                      value: 'Voice call',
                    ),
                    const SizedBox(height: 16),
                    _packageCard(
                      svgPath: 'assets/images/videoCallIcon.svg',
                      title: 'Video call',
                      subtitle: 'Video call with Mentor',
                      baseRate:
                      controller.packageResult!.videoRate ?? '0',
                      value: 'Video call',
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ✅ Overlay during payment
            if (controller.isApiLoading.value)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(16))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Processing payment...',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ✅ Summary row helper
  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: MyTextStyle.titleStyleCustom(
              13, FontWeight.w600, textGreyColor),
        ),
        Expanded(
          child: Text(
            value,
            style: MyTextStyle.titleStyleCustom(
                13, FontWeight.w500, Colors.grey[700]!),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ✅ Package card with dynamic price based on duration
  Widget _packageCard({
    required String svgPath,
    required String title,
    required String subtitle,
    required String baseRate,
    required String value,
  }) {
    return Obx(() {
      controller.count.value;
      final isSelected = controller.selectedPackage == value;
      final totalPrice = controller.formattedPrice(value);
      final baseDisplay =
          '\$${controller.getOnlyNumbers(baseRate)} / 30 min';

      return GestureDetector(
        onTap: () {
          controller.selectedPackage = value;
          controller.increment();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 28,
                  height: 28,
                 // color: isSelected ? primaryColor : Colors.grey,
                ),
              ),
              const SizedBox(width: 14),

              // Title + subtitle + base rate
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: MyTextStyle.titleStyleCustom(
                          16, FontWeight.bold, textGreyColor),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: MyTextStyle.titleStyleCustom(
                          12, FontWeight.normal, Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      baseDisplay,
                      style: MyTextStyle.titleStyleCustom(
                          11, FontWeight.w500, Colors.grey),
                    ),
                  ],
                ),
              ),

              // ✅ Total price based on selected duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    totalPrice,
                    style: MyTextStyle.titleStyleCustom(
                        18, FontWeight.bold,
                        isSelected ? primaryColor : textGreyColor),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    controller.formattedDuration,
                    style: MyTextStyle.titleStyleCustom(
                        11, FontWeight.w500, Colors.grey),
                  ),
                ],
              ),

              const SizedBox(width: 8),
              Radio<String>(
                activeColor: primaryColor,
                value: value,
                groupValue: controller.selectedPackage,
                onChanged: (val) {
                  controller.selectedPackage = val;
                  controller.increment();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}