import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_models/get_slots_mentor_model.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/check_appointment_slot_model.dart';
import '../../../data/apis/api_models/get_user_model.dart';

class UpdateDaysController extends GetxController {
  final isLoading = false.obs;
  final isUpdate = false.obs;
  String? slotId;

  // Initialize with null to detect if times have been set
  Map<String, Map<String, TimeOfDay?>> workingHours = {
    'Monday': {'Open': null, 'Close': null},
    'Tuesday': {'Open': null, 'Close': null},
    'Wednesday': {'Open': null, 'Close': null},
    'Thursday': {'Open': null, 'Close': null},
    'Friday': {'Open': null, 'Close': null},
    'Saturday': {'Open': null, 'Close': null},
    'Sunday': {'Open': null, 'Close': null},
  };

  Map<String, Map<String, TimeOfDay>> breakHours = {
    'Monday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Tuesday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Wednesday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Thursday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Friday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Saturday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
    'Sunday': {
      'Open': const TimeOfDay(hour: 13, minute: 0),
      'Close': const TimeOfDay(hour: 14, minute: 0)
    },
  };

  Map<String, bool> dayOpened = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };

  Map<String, bool> breakEnable = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };

  Map<String, String?> parameter = Get.parameters;

  List<CheckAppointmentSlotResult> mondaySlots = [];
  List<CheckAppointmentSlotResult> tuesdaySlots = [];
  List<CheckAppointmentSlotResult> wednesdaySlots = [];
  List<CheckAppointmentSlotResult> thursdaySlots = [];
  List<CheckAppointmentSlotResult> fridaySlots = [];
  List<CheckAppointmentSlotResult> saturdaySlots = [];
  List<CheckAppointmentSlotResult> sundaySlots = [];

  // Track if times have been modified
  Map<String, bool> timesModified = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };

  void showMyTimePicker(
      BuildContext context, String day, String timeType, selectionType) async {
    // Get current time or default
    TimeOfDay initialTime;
    if (selectionType == 'actual') {
      initialTime = workingHours[day]![timeType] ??
          (timeType == 'Open'
              ? const TimeOfDay(hour: 9, minute: 0)
              : const TimeOfDay(hour: 17, minute: 0));
    } else {
      initialTime = breakHours[day]![timeType]!;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff2EB9D5),
            colorScheme: const ColorScheme.light(
              primary: Color(0xff2EB9D5),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (selectionType == 'actual') {
        workingHours[day]![timeType] = picked;
        timesModified[day] = true;

        // Validate that close time is after open time
        if (timeType == 'Close' && workingHours[day]!['Open'] != null) {
          final openMinutes = workingHours[day]!['Open']!.hour * 60 +
              workingHours[day]!['Open']!.minute;
          final closeMinutes = picked.hour * 60 + picked.minute;

          if (closeMinutes <= openMinutes) {
            CommonWidgets.showMyToastMessage(
              "Close time must be after open time",
            );
            return;
          }
        }

        if (timeType == 'Open' && workingHours[day]!['Close'] != null) {
          final openMinutes = picked.hour * 60 + picked.minute;
          final closeMinutes = workingHours[day]!['Close']!.hour * 60 +
              workingHours[day]!['Close']!.minute;

          if (closeMinutes <= openMinutes) {
            CommonWidgets.showMyToastMessage(
              "Open time must be before close time",
            );
            return;
          }
        }

        getMentorSlots(context, day, "picker");
      } else {
        breakHours[day]![timeType] = picked;
      }
      increment();
    }
  }

  final count = 0.obs;

  List<String> daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Map<String, int> dayList = {
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6
  };

  @override
  void onInit() {
    super.onInit();
    loadInitialSlots();
  }

  Future<void> loadInitialSlots() async {
    isLoading.value = true;

    // Load all days in parallel for better performance
    await Future.wait(
      daysList.map((day) => getMentorSlots(Get.context!, day, "init")),
    );

    isLoading.value = false;
    increment();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  List<CheckAppointmentSlotResult> getSlotIndexData(int index) {
    switch (index) {
      case 0:
        return mondaySlots;
      case 1:
        return tuesdaySlots;
      case 2:
        return wednesdaySlots;
      case 3:
        return thursdaySlots;
      case 4:
        return fridaySlots;
      case 5:
        return saturdaySlots;
      case 6:
        return sundaySlots;
      default:
        return [];
    }
  }

  Future<void> getMentorSlots(
      BuildContext context, String day, String callOn) async {
    try {
      // For init, just get existing slots
      if (callOn == "init") {
        Map<String, dynamic> bodyParameterInit = {
          'user_id': LocalData.userId,
          'day': day,
        };

        CheckAppointmentSlotModel? checkAppointmentSlotModel =
        await ApiMethods.checkAppointmentSloteApi(
            bodyParams: bodyParameterInit);

        if (checkAppointmentSlotModel != null &&
            checkAppointmentSlotModel.status == '1' &&
            checkAppointmentSlotModel.result != null &&
            checkAppointmentSlotModel.result!.isNotEmpty) {

          _updateDaySlots(day, checkAppointmentSlotModel.result!);

          // Set day as opened and extract times from first slot
          dayOpened[day] = true;

          // Parse times from existing slots if available
          if (checkAppointmentSlotModel.result!.isNotEmpty) {
            final firstSlot = checkAppointmentSlotModel.result!.first;
            final lastSlot = checkAppointmentSlotModel.result!.last;

            // Extract times if they have actual time data
            if (firstSlot.time != null && firstSlot.time!.isNotEmpty) {
              try {
                final parsedOpen = _parseTimeFromSlot(firstSlot.time!);
                final parsedClose = _parseTimeFromSlot(lastSlot.time!);

                workingHours[day]!['Open'] = parsedOpen;
                workingHours[day]!['Close'] = parsedClose;
              } catch (e) {
                // If parsing fails, set defaults
                workingHours[day]!['Open'] = const TimeOfDay(hour: 9, minute: 0);
                workingHours[day]!['Close'] = const TimeOfDay(hour: 17, minute: 0);
              }
            }
          }
        } else {
          // No existing slots, set defaults
          workingHours[day]!['Open'] = const TimeOfDay(hour: 9, minute: 0);
          workingHours[day]!['Close'] = const TimeOfDay(hour: 17, minute: 0);
        }
      } else {
        // For toggle or picker, generate new slots based on current times
        final openTime = workingHours[day]!['Open'];
        final closeTime = workingHours[day]!['Close'];

        if (openTime == null || closeTime == null) {
          // Set defaults if not set
          workingHours[day]!['Open'] = const TimeOfDay(hour: 9, minute: 0);
          workingHours[day]!['Close'] = const TimeOfDay(hour: 17, minute: 0);
        }

        Map<String, dynamic> bodyParameter = {
          'user_id': LocalData.userId,
          'day': day,
          'start_time': (workingHours[day]!['Open'] ?? const TimeOfDay(hour: 9, minute: 0))
              .format(context),
          'close_time': (workingHours[day]!['Close'] ?? const TimeOfDay(hour: 17, minute: 0))
              .format(context),
        };

        CheckAppointmentSlotModel? checkAppointmentSlotModel =
        await ApiMethods.checkAppointmentSloteApi(bodyParams: bodyParameter);

        if (checkAppointmentSlotModel != null &&
            checkAppointmentSlotModel.status == '1') {
          _updateDaySlots(day, checkAppointmentSlotModel.result!);
        }
      }

      increment();
    } catch (e) {
      print('Error getting mentor slots for $day: $e');
      CommonWidgets.showMyToastMessage("Error loading slots for $day");
    }
  }

  void _updateDaySlots(String day, List<CheckAppointmentSlotResult> slots) {
    switch (day) {
      case 'Monday':
        mondaySlots = slots;
        break;
      case 'Tuesday':
        tuesdaySlots = slots;
        break;
      case 'Wednesday':
        wednesdaySlots = slots;
        break;
      case 'Thursday':
        thursdaySlots = slots;
        break;
      case 'Friday':
        fridaySlots = slots;
        break;
      case 'Saturday':
        saturdaySlots = slots;
        break;
      case 'Sunday':
        sundaySlots = slots;
        break;
    }
  }

  TimeOfDay _parseTimeFromSlot(String timeString) {
    // Parse time strings like "9:00 AM" or "17:00"
    try {
      final cleaned = timeString.trim();
      final parts = cleaned.split(' ');
      final timeParts = parts[0].split(':');

      int hour = int.parse(timeParts[0]);
      int minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

      // Handle AM/PM if present
      if (parts.length > 1) {
        final period = parts[1].toUpperCase();
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  Future<void> clickOnUpdate(BuildContext context) async {
    isUpdate.value = true;

    List<Future<bool>> apiCalls = [];

    dayOpened.forEach((day, isOpened) {
      if (isOpened) {
        apiCalls.add(callingApi(context, day, dayList[day] ?? 0));
      }
    });

    try {
      List<bool> results = await Future.wait(apiCalls);
      bool allSuccess = results.every((result) => result);

      if (allSuccess) {
        CommonWidgets.showMyToastMessage("Schedule updated successfully");
        Get.back();
      } else {
        CommonWidgets.showMyToastMessage("Some updates failed. Please try again.");
      }
    } catch (e) {
      CommonWidgets.showMyToastMessage("Update failed. Please try again.");
      print("Error updating schedule: $e");
    }

    isUpdate.value = false;
    increment();
  }

  Future<bool> callingApi(BuildContext context, String day, int index) async {
    try {
      List<String> slotTime = [];
      for (int i = 0; i < getSlotIndexData(index).length; i++) {
        if (getSlotIndexData(index)[i].availableSlot == "Yes") {
          slotTime.add(getSlotIndexData(index)[i].time ?? "");
        }
      }

      final openTime = workingHours[day]!['Open'] ?? const TimeOfDay(hour: 9, minute: 0);
      final closeTime = workingHours[day]!['Close'] ?? const TimeOfDay(hour: 17, minute: 0);
      
      print("Preparing to update $day with open time: ${openTime.format(context)}, close time: ${closeTime.format(context)}, slots: $slotTime");

      Map<String, dynamic> bodyParams = {
        "user_id": LocalData.userId,
        "day": day,
        "start_time": openTime.format(context),
        "close_time": closeTime.format(context),
        "slote_time": slotTime.join(", ")
      };

      print("Updating $day with params: $bodyParams");

      UserModel? userModel =
      await ApiMethods.addMultipleSlotsApi(bodyParams: bodyParams);

      if (userModel != null &&
          userModel.status != "0" &&
          userModel.result != null) {
        return true;
      } else {
        print("Add Details Failed for $day");
        return false;
      }
    } catch (e) {
      print("Error calling API for $day: $e");
      return false;
    }
  }

  TimeOfDay parseTimeOfDay(String time) {
    try {
      List<String> timeParts = time.split(" ");
      List<String> hourMinute = timeParts[0].split(":");
      int hour = int.parse(hourMinute[0]);
      int minute = hourMinute.length > 1 ? int.parse(hourMinute[1]) : 0;

      if (timeParts.length > 1) {
        String period = timeParts[1].toUpperCase();
        if (period == "PM" && hour != 12) {
          hour += 12;
        } else if (period == "AM" && hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  bool isAnyDayEnabled() {
    return dayOpened.values.any((isOpened) => isOpened);
  }
}