import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../routes/app_pages.dart';

class BookAppointmentController extends GetxController {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<GetAvailableSlotsResult> slotsList = [];

  // ✅ NEW: multiple selected indexes
  List<int> selectedIndexes = [];

  bool loader = false;

  final count = 0.obs;
  final isLoading = true.obs;

  Map<String, String?> parameter = Get.parameters;

  @override
  void onInit() {
    super.onInit();
    getSlots();
  }

  @override
  void onReady() => super.onReady();

  @override
  void onClose() => super.onClose();

  void increment() => count.value++;

  DateTime parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year, now.month, now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      59,
    );
  }

  bool isDateBeforeToday(DateTime date) {
    final today = DateTime.now();
    return date.isBefore(DateTime(today.year, today.month, today.day));
  }

  bool isSlotTimePassed(String time) {
    final now = DateTime.now();
    if (isSameDay(selectedDay, now)) {
      final slotDateTime = parseTime(time);
      return slotDateTime.isBefore(now) &&
          !(slotDateTime.hour == now.hour &&
              slotDateTime.minute == now.minute);
    }
    return false;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedIndexes = []; // ✅ clear all selections
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
    increment();
    getSlots();
  }

  // ✅ NEW: toggle slot selection — must be consecutive
  void toggleSlot(int index) {
    if (selectedIndexes.contains(index)) {
      // Deselect — remove from index onwards if not at edges
      final pos = selectedIndexes.indexOf(index);
      // Only allow deselect from start or end of selection
      if (pos == 0) {
        selectedIndexes.removeAt(0);
      } else if (pos == selectedIndexes.length - 1) {
        selectedIndexes.removeLast();
      } else {
        // Middle tap — reset selection to just this slot
        selectedIndexes = [index];
      }
    } else {
      if (selectedIndexes.isEmpty) {
        // First selection
        selectedIndexes = [index];
      } else {
        final minSelected = selectedIndexes.reduce((a, b) => a < b ? a : b);
        final maxSelected = selectedIndexes.reduce((a, b) => a > b ? a : b);

        if (index == maxSelected + 1) {
          // ✅ Consecutive after last — add
          selectedIndexes.add(index);
        } else if (index == minSelected - 1) {
          // ✅ Consecutive before first — add
          selectedIndexes.insert(0, index);
        } else {
          // Not consecutive — reset to new selection
          selectedIndexes = [index];
        }
      }
    }
    increment();
  }

  // ✅ Get start time from first selected slot
  String? get startTime {
    if (selectedIndexes.isEmpty) return null;
    final minIdx = selectedIndexes.reduce((a, b) => a < b ? a : b);
    return slotsList[minIdx].start;
  }

  // ✅ Get end time from last selected slot
  String? get endTime {
    if (selectedIndexes.isEmpty) return null;
    final maxIdx = selectedIndexes.reduce((a, b) => a > b ? a : b);
    return slotsList[maxIdx].end;
  }

  // ✅ Calculate total duration in minutes
  int get totalDurationMinutes {
    return selectedIndexes.length * 30;
  }

  // ✅ Format duration: "1h 30m" or "30m"
  String get formattedDuration {
    final total = totalDurationMinutes;
    if (total == 0) return '';
    final hours = total ~/ 60;
    final minutes = total % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  Future<void> getSlots() async {
    loader = true;
    slotsList = [];
    selectedIndexes = [];
    increment();

    try {
      Map<String, dynamic> bodyParams = {
        'user_id': parameter[ApiKeyConstants.mentorId] ?? '',
        'date': DateFormat('yyyy-MM-dd').format(selectedDay),
        'day': DateFormat('EEEE').format(selectedDay),
      };

      GetAvailableSlotsModel? model = await ApiMethods.getAvailableSlotsApi(
        bodyParams: bodyParams,
      );

      if (model != null && model.status == '1' && model.result != null) {
        for (final slot in model.result!) {
          if (slot.available == false) continue;
          if (slot.start != null && isSlotTimePassed(slot.start!)) continue;
          slotsList.add(slot);
        }

        slotsList.sort((a, b) {
          if (a.start == null || b.start == null) return 0;
          return parseTime(a.start!).compareTo(parseTime(b.start!));
        });

        debugPrint('✅ Available slots: ${slotsList.length}');
      } else {
        slotsList = [];
        debugPrint('❌ No slots available');
      }
    } catch (e) {
      slotsList = [];
      debugPrint('❌ Error getting slots: $e');
    } finally {
      loader = false;
      increment();
    }
  }

  void clickOnNext() {
    if (selectedIndexes.isEmpty) {
      CommonWidgets.snackBarView(title: 'Please select a time slot');
      return;
    }

    // Double-check first slot hasn't expired
    if (startTime != null && isSlotTimePassed(startTime!)) {
      CommonWidgets.snackBarView(title: 'Selected slot is no longer available');
      selectedIndexes = [];
      increment();
      getSlots();
      return;
    }

    // ✅ Send start_time and end_time
    Map<String, String> data = {
      ApiKeyConstants.mentorId: parameter[ApiKeyConstants.mentorId] ?? '',
      ApiKeyConstants.appointment_date:
      DateFormat('yyyy-MM-dd').format(selectedDay),
      ApiKeyConstants.time: startTime ?? '',       // "16:00"
      'start_time': startTime ?? '',               // "16:00"
      'end_time': endTime ?? '',                   // "17:30"
      'duration': totalDurationMinutes.toString(), // "90"
    };

    debugPrint('✅ Booking: $startTime → $endTime ($formattedDuration)');
    Get.toNamed(Routes.SELECT_PACKAGE, parameters: data);
  }
}

// get_available_slots_model.dart

class GetAvailableSlotsModel {
  String? status;
  List<GetAvailableSlotsResult>? result;

  GetAvailableSlotsModel({this.status, this.result});

  factory GetAvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableSlotsModel(
      status: json['status']?.toString(),
      result: json['result'] != null
          ? List<GetAvailableSlotsResult>.from(
          json['result'].map((x) => GetAvailableSlotsResult.fromJson(x)))
          : null,
    );
  }
}

class GetAvailableSlotsResult {
  String? start;
  String? end;
  bool? available;

  GetAvailableSlotsResult({this.start, this.end, this.available});

  factory GetAvailableSlotsResult.fromJson(Map<String, dynamic> json) {
    return GetAvailableSlotsResult(
      start: json['start'],
      end: json['end'],
      available: json['available'],
    );
  }
}




// import 'package:intl/intl.dart';
// import 'package:mindtomind/common/common_widgets.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../../data/apis/api_constants/api_key_constants.dart';
// import '../../../data/apis/api_methods/api_methods.dart';
// import '../../../data/apis/api_models/get_slots_model.dart';
// import '../../../routes/app_pages.dart';
//
// class BookAppointmentController extends GetxController {
//   CalendarFormat calendarFormat = CalendarFormat.month;
//   DateTime selectedDay = DateTime.now();
//   DateTime focusedDay = DateTime.now();
//   List<GetSlotsResult>? slotsList;
//   bool loader = false;
//   int? selectedIndex;
//   String? selectedTime;
//
//   final count = 0.obs;
//   final isLoading = true.obs;
//
//   Map<String, String?> parameter = Get.parameters;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getSlots();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   void increment() => count.value++;
//
//   DateTime parseTime(String time) {
//     // Split the time string (e.g., "15:00")
//     List<String> timeParts = time.split(':');
//     // Get current date
//     DateTime now = DateTime.now();
//
//     // Create a DateTime using the current date and parsed hours/minutes
//     return DateTime(now.year, now.month, now.day, int.parse(timeParts[0]),
//         int.parse(timeParts[1]));
//   }
//
//   bool isDateBeforeToday(DateTime date) {
//     final today = DateTime.now();
//     // Compare only the date parts, ignore the time
//     return date.isBefore(DateTime(today.year, today.month, today.day));
//   }
//
//   Future<void> getSlots() async {
//   loader = true;
//     Map<String, dynamic> bodyParameter = {
//       'user_id': parameter[ApiKeyConstants.mentorId] ?? '',
//       'date': DateFormat('yyyy-MM-dd').format(selectedDay),
//       'day': DateFormat('EEEE').format(selectedDay)
//     };
//     GetSlotsModel? getSlotsModel =
//         await ApiMethods.getSlotsApi(bodyParams: bodyParameter);
//     if (getSlotsModel != null && getSlotsModel.status == '1') {
//       slotsList = [];
//       List<GetSlotsResult>? tempList;
//       tempList = getSlotsModel.result;
//
//       if (tempList != null && tempList.isNotEmpty) {
//         for (int i = 0; i < tempList!.length; i++) {
//           if (tempList[i].availableSlot == "Yes") {
//             slotsList!.add(tempList[i]);
//           }
//         }
//         increment();
//       } else {
//         slotsList = [];
//         increment();
//       }
//       print("status  ${slotsList}");
//     } else {
//       slotsList = [];
//       print('Get slots failed.....');
//       increment();
//     }
//     loader = false;
//   }
//
//   void clickOnNext() {
//     if (selectedIndex == null) {
//       CommonWidgets.snackBarView(title: 'Choose slot first');
//     } else {    Map<String, String> data = {
//       ApiKeyConstants.mentorId: parameter[ApiKeyConstants.mentorId] ?? '',
//       ApiKeyConstants.appointment_date:
//       DateFormat('yyyy-MM-dd').format(selectedDay),
//       ApiKeyConstants.time: selectedTime ?? ""
//     };
//
//       Get.toNamed(Routes.SELECT_PACKAGE, parameters: data);
//     }
//   }
// }
