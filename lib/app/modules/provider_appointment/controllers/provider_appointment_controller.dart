import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/add_video_connection_model.dart';
import 'package:mindtomind/app/data/apis/api_models/chat_token_model.dart';
import 'package:mindtomind/app/data/apis/api_models/get_appointmentlist_model.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';

class ProviderAppointmentController extends GetxController {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey2 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey3 =
  GlobalKey<RefreshIndicatorState>();
  List<GetAppointmentListResult> upcomingList = [];
  List<GetAppointmentListResult> completedList = [];
  List<GetAppointmentListResult> cancelledList = [];
  AddVideoConnectionResult? addVideoConnectionResult;
  ChatTokenResult? chatTokenResult;
  final count = 0.obs;
  final isLoading = true.obs;

  Timer? _timer;

  @override
  void onInit() async {
    super.onInit();
    await _fetchAllData();
    isLoading.value = false;
    increment();
   // _startTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

// Call this when screen comes back into view (e.g., from route observer or onResume)
  void onScreenResume() async {
    await _fetchAllData();
    increment();
    _startTimer();
  }

// Call this when screen goes out of view
  void onScreenPause() {
    _stopTimer();
  }

  void _startTimer() {
    _stopTimer(); // Prevent duplicate timers
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _fetchAllData();
      increment();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchAllData() async {
    await getUpcomingList();
    await getCompleteList();
    await getCancelList();
  }

  void increment() => count.value++;

  Future<void> getUpcomingList() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.mentorId: LocalData.userId,
      ApiKeyConstants.type: LocalData.userType,
      ApiKeyConstants.status: 'Accept',
    };
    GetAppointmentListModel? getAppointmentListModel =
        await ApiMethods.getAppointmentMentorApi(bodyParams: bodyParam);
    if (getAppointmentListModel != null &&
        getAppointmentListModel.status == '1') {
      upcomingList = getAppointmentListModel.result!;

      print("Get appointment  list successfully.....${upcomingList[1].status}");
    } else {
      print('Get appointment  list failed.....');
      // CommonWidgets.showMyToastMessage(
      //     getAppointmentListModel?.message ?? 'Get mentor list  failed.....');
    }
    increment();
  }

  Future<void> getCancelList() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.mentorId: LocalData.userId,
      ApiKeyConstants.type: LocalData.userType,
      ApiKeyConstants.status: 'Cancel',
    };
    GetAppointmentListModel? getAppointmentListModel =
        await ApiMethods.getAppointmentMentorApi(bodyParams: bodyParam);
    if (getAppointmentListModel != null &&
        getAppointmentListModel.status == '1') {
      cancelledList = getAppointmentListModel.result!;

      print("Get cancel appointment  list successfully complete.....");
    } else {
      print('Get cancel appointment  list failed.....');
      // CommonWidgets.showMyToastMessage(getAppointmentListModel?.message ??
      //     'Get cancel appointment list  failed.....');
    }
    increment();
  }

  Future<void> getCompleteList() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.mentorId: LocalData.userId,
      ApiKeyConstants.type: LocalData.userType,
      ApiKeyConstants.status: 'Complete',
    };
    GetAppointmentListModel? getAppointmentListModel =
        await ApiMethods.getAppointmentMentorApi(bodyParams: bodyParam);
    if (getAppointmentListModel != null &&
        getAppointmentListModel.status == '1') {
      completedList = getAppointmentListModel.result!;
      print("Get complete appointment  list successfully complete.....");
    } else {
      print('Get complete appointment  list failed.....');
      // CommonWidgets.showMyToastMessage(getAppointmentListModel?.message ??
      //     'Get complete appointment list  failed.....');
    }
    increment();
  }

  addVideoConnection(int index) async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.userId: LocalData.userId,
      ApiKeyConstants.otherUserId: upcomingList[index].userDetails!.id,
      ApiKeyConstants.channelName: createChannelName(),
      ApiKeyConstants.appointmentId: upcomingList[index].id,
    };
    isLoading.value = true;
    AddVideoConnectionModel? addVideoConnectionModel =
        await ApiMethods.addVideoConnectionApi(bodyParams: bodyParam);
    if (addVideoConnectionModel != null &&
        addVideoConnectionModel.status == '1') {
      addVideoConnectionResult = addVideoConnectionModel.result;
    } else {
      print('Submit Contact  failed.....');
      CommonWidgets.showMyToastMessage(
          addVideoConnectionModel?.message ?? 'Submit Contact  failed.....');
    }
    isLoading.value = false;
    increment();
  }

  Future<void> chatApiCall(int index) async {
    Map<String, dynamic> bodyParam = {
      "sender_id": LocalData.userId,
      "receiver_id": upcomingList[index].userDetails!.id,
      "appointment_id": upcomingList[index].id,
    };
    isLoading.value = true;
    ChatTokenModel? chatTokenModel =
        await ApiMethods.chatApi(bodyParams: bodyParam);
    if (chatTokenModel != null && chatTokenModel.status == '1') {
      chatTokenResult = chatTokenModel.result;
    } else {
      print('Submit Contact  failed.....');
      CommonWidgets.showMyToastMessage(
          chatTokenModel?.message ?? 'Submit Contact  failed.....');
    }
    isLoading.value = false;
    increment();
  }

  String createChannelName({int length = 8}) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return 'channel_' +
        List.generate(length, (index) => chars[random.nextInt(chars.length)])
            .join();
  }
}
