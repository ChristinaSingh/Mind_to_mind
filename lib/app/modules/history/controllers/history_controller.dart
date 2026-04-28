import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/chat_token_model.dart';
import '../../../data/apis/api_models/get_history_data.dart';

class HistoryController extends GetxController {
  List<NotificationResult> historyList = [];
  List<NotificationResult> messageList = [];
  List<NotificationResult> audioList = [];
  List<NotificationResult> videoList = [];

  final isLoading = true.obs;
  final count = 0.obs;

  ChatTokenResult? chatTokenResult;

  @override
  void onInit() {
    super.onInit();
    getAllHistoryListApi();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getAllHistoryListApi(isFromTimer: true);
    });
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

  Future<void> chatApiCall(int index) async {
    if (index >= messageList.length) {
      CommonWidgets.showMyToastMessage('Invalid appointment selected');
      return;
    }

    try {
      Map<String, dynamic> bodyParam = {
        "sender_id": LocalData.userId,
        "receiver_id": messageList[index].mentorId,
        "appointment_id": messageList[index].id,
      };

      log("Chat API params: $bodyParam");

      // Show loading indicator
      CommonWidgets.showMyToastMessage('Loading chat...');

      ChatTokenModel? chatTokenModel =
      await ApiMethods.chatApi(bodyParams: bodyParam);

      if (chatTokenModel != null && chatTokenModel.status == '1') {
        chatTokenResult = chatTokenModel.result;
        log("Chat token received successfully");
      } else {
        log('Chat API failed: ${chatTokenModel?.message}');
        CommonWidgets.showMyToastMessage(
          chatTokenModel?.message ?? 'Failed to load chat',
        );
        chatTokenResult = null;
      }
    } catch (e) {
      log('Error in chat API call: $e');
      CommonWidgets.showMyToastMessage('An error occurred while loading chat');
      chatTokenResult = null;
    }

    increment();
  }

  Future<void> getAllHistoryListApi({bool isFromTimer = false}) async {

    // Show loader only first time
    if (!isFromTimer) {
      isLoading.value = true;
    }

    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.mentorId: LocalData.userId ?? '',
        ApiKeyConstants.type: LocalData.userType,
      };

      log("Fetching history with params: $bodyParam");

      GetNotificationModel? getNotificationModel =
      await ApiMethods.getAllHistory(bodyParams: bodyParam);

      if (getNotificationModel != null &&
          getNotificationModel.status == '1' &&
          getNotificationModel.result != null) {

        /// 🔥 VERY IMPORTANT – Clear before adding
        historyList.clear();
        messageList.clear();
        audioList.clear();
        videoList.clear();

        historyList.addAll(getNotificationModel.result!);

        log("Total history items: ${historyList.length}");

        for (int i = 0; i < historyList.length; i++) {
          final packageId = historyList[i].packageId?.trim();

          if (packageId == null || packageId.isEmpty) {
            continue;
          }

          switch (packageId) {
            case "Messaging":
              messageList.add(historyList[i]);
              break;
            case "Voice call":
              audioList.add(historyList[i]);
              break;
            case "Video call":
              videoList.add(historyList[i]);
              break;
          }
        }

        _sortListByDate(messageList);
        _sortListByDate(audioList);
        _sortListByDate(videoList);

        log("Categorized - Messages: ${messageList.length}, "
            "Audio: ${audioList.length}, Video: ${videoList.length}");
      }
    } catch (e) {
      log('Error fetching history: $e');
    } finally {
      if (!isFromTimer) {
        isLoading.value = false;
      }
      update(); // if using GetBuilder
    }
  }


  void _sortListByDate(List<NotificationResult> list) {
    list.sort((a, b) {
      try {
        // Sort by appointment date first
        final dateA = a.appointmentDate ?? '';
        final dateB = b.appointmentDate ?? '';

        if (dateA.isEmpty || dateB.isEmpty) return 0;

        final comparison = dateB.compareTo(dateA); // Most recent first

        // If dates are same, sort by time
        if (comparison == 0) {
          final timeA = a.time ?? '';
          final timeB = b.time ?? '';
          return timeB.compareTo(timeA);
        }

        return comparison;
      } catch (e) {
        log('Error sorting: $e');
        return 0;
      }
    });
  }

  String getFormattedStatus(String? status) {
    if (status == null || status.isEmpty) return 'Unknown';
    return status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase();
  }

  bool canOpenChat(String? status) {
    if (status == null) return false;
    final statusLower = status.toLowerCase();
    return statusLower == 'complete' || statusLower == 'ongoing';
  }
}