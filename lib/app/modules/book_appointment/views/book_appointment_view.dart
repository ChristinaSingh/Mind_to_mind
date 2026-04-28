import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/book_appointment_controller.dart';

class BookAppointmentView extends GetView<BookAppointmentController> {
  const BookAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonWidgets.appBar(title: 'Book Appointment'),
      bottomNavigationBar: Obx(() {
        controller.count.value;
        if (controller.slotsList.isEmpty ||
            controller.loader ||
            controller.selectedIndexes.isEmpty) {
          return const SizedBox();
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Summary bar showing selected range + duration
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: primaryColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${controller.startTime ?? ''} → ${controller.endTime ?? ''}',
                          style: const TextStyle(
                            color: primaryDarkColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        controller.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CommonWidgets.commonElevatedButton(
                onPressed: controller.clickOnNext,
                child: Text('Next', style: MyTextStyle.titleStyle16bw),
              ),
            ],
          ),
        );
      }),
      body: Obx(() {
        controller.count.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Calendar ─────────────────────────────────────────────
                Text('Select Date', style: MyTextStyle.titleStyle20bb),
                const SizedBox(height: 15),
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TableCalendar(
                      calendarFormat: controller.calendarFormat,
                      firstDay: DateTime.now(),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: controller.focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(controller.selectedDay, day),
                      enabledDayPredicate: (day) =>
                      !controller.isDateBeforeToday(day),
                      onDaySelected: controller.onDaySelected,
                      onPageChanged: (focusedDay) =>
                      controller.focusedDay = focusedDay,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                            color: primaryDarkColor,
                            fontWeight: FontWeight.bold),
                        selectedDecoration: const BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                        selectedTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        disabledTextStyle:
                        TextStyle(color: hintColor.withOpacity(0.5)),
                        outsideTextStyle: TextStyle(color: hintColor),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: primaryDarkColor),
                        leftChevronIcon: const Icon(Icons.chevron_left,
                            color: primaryColor),
                        rightChevronIcon: const Icon(Icons.chevron_right,
                            color: primaryColor),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: labelColor, fontWeight: FontWeight.w600),
                        weekendStyle: TextStyle(
                            color: labelColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ── Slot Header ───────────────────────────────────────────
                Row(
                  children: [
                    Text('Select Time Slot', style: MyTextStyle.titleStyle20bb),
                    const Spacer(),
                    if (controller.slotsList.isNotEmpty && !controller.loader)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.slotsList.length} available',
                          style: const TextStyle(
                              color: primaryDarkColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),

                // ✅ Hint text for multi-select
                if (controller.slotsList.isNotEmpty && !controller.loader)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Tap multiple consecutive slots to book longer sessions',
                      style: TextStyle(
                          fontSize: 12,
                          color: hintColor,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 15),

                // ── Slot Grid ─────────────────────────────────────────────
                if (controller.loader)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                              color: primaryColor, strokeWidth: 3),
                          const SizedBox(height: 16),
                          Text('Loading available slots...',
                              style:
                              TextStyle(color: labelColor, fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                else if (controller.slotsList.isEmpty)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: hintColor),
                          const SizedBox(height: 16),
                          Text('No slots available',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: labelColor)),
                          const SizedBox(height: 8),
                          Text('Please select another date',
                              style:
                              TextStyle(fontSize: 14, color: hintColor)),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.0,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: controller.slotsList.length,
                    itemBuilder: (context, index) {
                      final slot = controller.slotsList[index];
                      final isSelected =
                      controller.selectedIndexes.contains(index);

                      // ✅ Highlight edges of selection range
                      final isStart = controller.selectedIndexes.isNotEmpty &&
                          index ==
                              controller.selectedIndexes
                                  .reduce((a, b) => a < b ? a : b);
                      final isEnd = controller.selectedIndexes.isNotEmpty &&
                          index ==
                              controller.selectedIndexes
                                  .reduce((a, b) => a > b ? a : b);

                      final startFormatted = slot.start != null
                          ? DateFormat('hh:mm a')
                          .format(controller.parseTime(slot.start!))
                          : '--';
                      final endFormatted = slot.end != null
                          ? DateFormat('hh:mm a')
                          .format(controller.parseTime(slot.end!))
                          : '--';

                      return GestureDetector(
                        onTap: () => controller.toggleSlot(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor
                                : backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : outlineInputBorderDayColor,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ✅ Show START / END label on edge slots
                              if (isStart && isEnd)
                                _badgeText('Selected')
                              else if (isStart)
                                _badgeText('Start')
                              else if (isEnd)
                                  _badgeText('End'),

                              Text(
                                startFormatted,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : labelColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endFormatted,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.85)
                                      : hintColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _badgeText(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}