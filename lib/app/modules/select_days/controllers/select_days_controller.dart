import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/check_appointment_slot_model.dart';
import '../../../data/apis/api_models/get_user_model.dart';
import '../../../routes/app_pages.dart';

class SelectDaysController extends GetxController {
  final isLoading = false.obs;
  Map<String, Map<String, TimeOfDay>> workingHours = {
    'Monday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Tuesday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Wednesday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Thursday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Friday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Saturday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Sunday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
  };

  Map<String, Map<String, TimeOfDay>> breakHours = {
    'Monday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Tuesday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Wednesday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Thursday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Friday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Saturday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
    },
    'Sunday': {
      'Open': TimeOfDay(hour: 9, minute: 0),
      'Close': TimeOfDay(hour: 17, minute: 0)
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

  void showMyTimePicker(BuildContext context, String day, String timeType,
      selectionType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectionType == 'actual'
          ? workingHours[day]![timeType]!
          : breakHours[day]![timeType]!,
    );

    if (picked != null) {
      if (selectionType == 'actual') {
        workingHours[day]![timeType] = picked;
        getMentorSlots(context, day);
        increment();
      } else {
        breakHours[day]![timeType] = picked;
        increment();
      }
    }
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
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
        return sundaySlots;
    }
  }

  void getMentorSlots(BuildContext context, String day) async {
    Map<String, dynamic> bodyParameter = {
      'user_id': LocalData.userId,
      'day': day,
      'start_time': workingHours[day]!["Open"]!.format(context),
      'close_time': workingHours[day]!["Close"]!.format(context),
    };
    CheckAppointmentSlotModel? checkAppointmentSlotModel =
    await ApiMethods.checkAppointmentSloteApi(bodyParams: bodyParameter);
    if (checkAppointmentSlotModel != null &&
        checkAppointmentSlotModel.status == '1') {
      print("status  ${checkAppointmentSlotModel.result}");
      if (day == 'Monday') {
        mondaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Tuesday') {
        tuesdaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Wednesday') {
        wednesdaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Thursday') {
        thursdaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Friday') {
        fridaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Saturday') {
        saturdaySlots = checkAppointmentSlotModel.result!;
      } else if (day == 'Sunday') {
        sundaySlots = checkAppointmentSlotModel.result!;
      }
      print("$day slots are:::${checkAppointmentSlotModel.result!}");
      increment();
    } else {
      // slotsList = [];
      // print('Get slots failed.....');
    }
    increment();
  }

  // void clickOnAddTime(BuildContext context) async {
  //   Map<String, dynamic> bodyParamsForSetDays = {
  //     "user_id": parameter[ApiKeyConstants.userId] ?? '',
  //     "monday_start_time": dayOpened["Monday"] == true
  //         ? workingHours["Monday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "monday_close_time": dayOpened["Monday"] == true
  //         ? workingHours["Monday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "tuesday_start_time": dayOpened["Tuesday"] == true
  //         ? workingHours["Tuesday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "tuesday_close_time": dayOpened["Tuesday"] == true
  //         ? workingHours["Tuesday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "wednesday_start_time": dayOpened["Wednesday"] == true
  //         ? workingHours["Wednesday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "wednesday_close_time": dayOpened["Wednesday"] == true
  //         ? workingHours["Wednesday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "thursday_start_time": dayOpened["Thursday"] == true
  //         ? workingHours["Thursday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "thursday_close_time": dayOpened["Thursday"] == true
  //         ? workingHours["Thursday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "friday_start_time": dayOpened["Friday"] == true
  //         ? workingHours["Friday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "friday_close_time": dayOpened["Friday"] == true
  //         ? workingHours["Friday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "saturday_start_time": dayOpened["Saturday"] == true
  //         ? workingHours["Saturday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "saturday_close_time": dayOpened["Saturday"] == true
  //         ? workingHours["Saturday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "sunday_start_time": dayOpened["Sunday"] == true
  //         ? workingHours["Sunday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "sunday_close_time": dayOpened["Sunday"] == true
  //         ? workingHours["Sunday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "monday_start_break_time": breakEnable["Monday"] == true
  //         ? breakHours["Monday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "monday_close_break_time": breakEnable["Monday"] == true
  //         ? breakHours["Monday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "tuesday_start_break_time": breakEnable["Tuesday"] == true
  //         ? breakHours["Tuesday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "tuesday_close_break_time": breakEnable["Tuesday"] == true
  //         ? breakHours["Tuesday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "wednesday_start_break_time": breakEnable["Wednesday"] == true
  //         ? breakHours["Wednesday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "wednesday_close_break_time": breakEnable["Wednesday"] == true
  //         ? breakHours["Wednesday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "thursday_start_break_time": breakEnable["Thursday"] == true
  //         ? breakHours["Thursday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "thursday_close_break_time": breakEnable["Thursday"] == true
  //         ? breakHours["Thursday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "friday_start_break_time": breakEnable["Friday"] == true
  //         ? breakHours["Friday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "friday_close_break_time": breakEnable["Friday"] == true
  //         ? breakHours["Friday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "saturday_start_break_time": breakEnable["Saturday"] == true
  //         ? breakHours["Saturday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "saturday_close_break_time": breakEnable["Saturday"] == true
  //         ? breakHours["Saturday"]!["Close"]!.format(context)
  //         : "Closed",
  //     "sunday_start_break_time": breakEnable["Sunday"] == true
  //         ? breakHours["Sunday"]!["Open"]!.format(context)
  //         : "Closed",
  //     "sunday_close_break_time": breakEnable["Sunday"] == true
  //         ? breakHours["Sunday"]!["Close"]!.format(context)
  //         : "Closed",
  //   };
  //   isLoading.value = true;
  //   print("bodyParamsForSetDaysParams:::::$bodyParamsForSetDays");
  //   UserModel? userModel =
  //       await ApiMethods.addDaysApi(bodyParams: bodyParamsForSetDays);
  //   if (userModel != null &&
  //       userModel.status != "0" &&
  //       userModel.result != null) {
  //     isLoading.value = false;
  //     CommonWidgets.showMyToastMessage(userModel.message!);
  //     Get.offNamed(Routes.LOGIN);
  //   } else {
  //     isLoading.value = false;
  //     print("Add Details Failed....");
  //     CommonWidgets.showMyToastMessage(userModel!.message!);
  //   }
  //   isLoading.value = false;
  // }

  Map<String,int> dayList={
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6
  };

  void clickOnAddTime(BuildContext context) async {
    List<Future<bool>> apiCalls = [];

    dayOpened.forEach((day, isOpened) {
      print('$day: $isOpened');
      if (isOpened) {
        apiCalls.add(callingApi(context, day, dayList[day] ?? 0));
      }
    });

    // Wait for all API calls to finish and collect the results
    List<bool> results = await Future.wait(apiCalls);

    // Check if all API calls were successful
    bool allSuccess = results.every((result) => result);

    // If all calls are successful, navigate to the next screen
    if (allSuccess) {
      // Navigate to the next page
      // For example:
      isLoading.value = false;
      Get.offNamed(Routes.LOGIN);
    } else {
      // Handle failure (you can show a toast message or something else)
      print("Some API calls failed.");
    }
  }

  Future<bool> callingApi(BuildContext context, String day, int index) async {
    List<String> slotTime = [];
    for (int i = 0; i < getSlotIndexData(index).length; i++) {
      if (getSlotIndexData(index)[i].available == true) {
        slotTime.add(getSlotIndexData(index)[i].time ?? "");
      }
    }
    Map<String, dynamic> bodyParams = {
      "user_id": parameter[ApiKeyConstants.userId] ?? '',
      "day": day,
      "start_time": workingHours[day]!["Open"]!.format(context),
      "close_time": workingHours[day]!["Close"]!.format(context),
      "slote_time": slotTime.join(", ")
    };

    isLoading.value = true;
    print("bodyParamsForSetDaysParams:::::$bodyParams");

    UserModel? userModel =
    await ApiMethods.addMultipleSlotsApi(bodyParams: bodyParams);



    if (userModel != null && userModel.status != "0" && userModel.result != null) {
      return true; // Success
    } else {
      print("Add Details Failed....");
      return false; // Failure
    }
  }


  bool isAnyDayEnabled() {
    return dayOpened.values.any((isOpened) => isOpened);
  }
  }
