import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../../common/text_styles.dart';
import '../../../data/apis/api_constants/api_key_constants.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/add_video_connection_model.dart';
import '../../../data/apis/api_models/chat_token_model.dart';
import '../../../data/apis/api_models/get_appointmentlist_model.dart';
import '../../../data/apis/api_models/get_update_status_model.dart';
import '../../../routes/app_pages.dart';

class ProviderHomeController extends GetxController {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey4 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey5 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey6 =
  GlobalKey<RefreshIndicatorState>();
  List<GetAppointmentListResult> upcomingList = [];
  List<GetAppointmentListResult> completeList = [];
  List<GetAppointmentListResult> cancelList = [];
  ChatTokenResult? chatTokenResult;
  AddVideoConnectionResult? addVideoConnectionResult;

  final count = 0.obs;
  final tabIndex = 0.obs;
  final isLoading = true.obs;
  Timer? _timer;

  @override
  void onInit() async {
    super.onInit();
    await getUpcomingList();
    await getCompleteList();
    await getCancelList();
    isLoading.value = false;
    increment();
    _startTimer();
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

  void onScreenResume() async {
    await _fetchAllData();
   // _startTimer();
  }

  void onScreenPause() {
    _stopTimer();
  }

  void _startTimer() {
    _stopTimer(); // prevent duplicate timers
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fetchAllData();
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
    increment();
  }

  void increment() => count.value++;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    print('Tab index......$index');
    increment();
  }

  void clickOnItem(int index) {
    switch (tabIndex.value) {
      case 0:
        {
          Get.toNamed(Routes.PROVIDER_CLIENT_DETAIL,
              arguments: upcomingList[index]);
          break;
        }
      case 1:
        {
          Get.toNamed(Routes.PROVIDER_CLIENT_DETAIL,
              arguments: completeList[index]);
          break;
        }
      case 2:
        {
          Get.toNamed(Routes.PROVIDER_CLIENT_DETAIL,
              arguments: cancelList[index]);
          break;
        }
    }
  }

  Future<void> getUpcomingList() async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.mentorId: LocalData.userId,
      ApiKeyConstants.type: LocalData.userType,
      ApiKeyConstants.status: 'Pending',
    };
    GetAppointmentListModel? getAppointmentListModel =
        await ApiMethods.getAppointmentMentorApi(bodyParams: bodyParam);
    if (getAppointmentListModel != null &&
        getAppointmentListModel.status == '1') {
      upcomingList = getAppointmentListModel.result!;
      print("Get appointment  list successfully complete.....");
    } else {
      print('Get appointment  list failed.....');
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
      cancelList = getAppointmentListModel.result!;
      print("Get cancel appointment  list successfully complete.....");
    } else {
      print('Get cancel appointment  list failed.....');
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
      completeList = getAppointmentListModel.result!;
      print("Get complete appointment  list successfully complete.....");
    } else {
      print('Get complete appointment  list failed.....');
    }
    increment();
  }

  void showCancelDialog(BuildContext context, String status, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary3Color,
          title: Text("$status Booking",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to $status the booking?"),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Get.back();
              },
        borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffBEBEBE)),
                child: Center(
                    child: Text(
                      'No',
                      style: MyTextStyle.titleStyleCustom(16, FontWeight.w600, primary3Color),
                    )),
              ),
            ),
            InkWell(
              onTap: () {
                updateStatus(status, id);
                Get.back();

              },
        borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor),
                child: Center(
                  child: Text(
                    'Yes',
                    style: MyTextStyle.titleStyleCustom(16, FontWeight.w600, primary3Color),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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

  void updateStatus(String status, String id) async {
    Map<String, dynamic> bodyParam = {
      ApiKeyConstants.status: status,
      ApiKeyConstants.appointmentId: id,
      ApiKeyConstants.userId: LocalData.userId,
    };
    UpdateStatusModel? updateStatusModel =
        await ApiMethods.mentorUpdateAppointmentStatusApi(
            bodyParams: bodyParam);
    if (updateStatusModel != null && updateStatusModel.status == '1') {
      CommonWidgets.showMyToastMessage(updateStatusModel.message ??
          'Update status  successfully complete.....');
      print("Update status successfully complete.....");
      isLoading.value = true;
      increment();
      await getUpcomingList();
      await getCompleteList();
      await getCancelList();
      isLoading.value = false;
      increment();
    } else {
      print('Update status failed.....');
      CommonWidgets.showMyToastMessage(
          updateStatusModel?.message ?? 'Update status  failed.....');
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary3Color,
          surfaceTintColor: primary3Color,
          title: Center(
              child: Text(
            "Switch Account",
            style: MyTextStyle.titleStyle24bb,
          )),
          content: Container(
              height: 300.px,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you sure you want to switch accounts?",
                    style: MyTextStyle.titleStyle16b,
                    textAlign: TextAlign.center,
                  ),
                  SvgPicture.asset(
                    "assets/icons/ic_both.svg",
                    height: 120.px,
                    width: 120.px,
                  ),
                  CommonWidgets.commonElevatedButton(
                      onPressed: () {
                        Get.back();
                        LocalData.showUserScreen = true;
                        Get.offAllNamed(Routes.SPLASH);
                      },
                      child: Text(
                        'Switch',
                        style: MyTextStyle.titleStyle16bw,
                      ),
                      buttonMargin: EdgeInsets.all(5.px)),
                  CommonWidgets.commonElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: MyTextStyle.titleStyle16gr,
                      ),
                      buttonColor: Colors.transparent)
                ],
              )),
        );
      },
    );
  }
}
