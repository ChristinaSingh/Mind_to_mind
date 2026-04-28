import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/app/data/apis/api_constants/api_key_constants.dart';
import 'package:mindtomind/app/data/apis/api_models/get_appointmentlist_model.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../../../common/common_widgets.dart';
import '../../../data/apis/api_methods/api_methods.dart';
import '../../../data/apis/api_models/chat_token_model.dart';

class AppointmentController extends GetxController {
  // Refresh indicator keys for pull-to-refresh
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey2 =
  GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey3 =
  GlobalKey<RefreshIndicatorState>();

  // Appointment lists
  List<GetAppointmentListResult> upcomingList = [];
  List<GetAppointmentListResult> completedList = [];
  List<GetAppointmentListResult> cancelledList = [];

  // Chat token result
  ChatTokenResult? chatTokenResult;

  // Observable states
  final count = 0.obs;
  final isLoading = true.obs;
  final isRefreshing = false.obs;

  // Timer for periodic refresh
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  /// Initialize data on controller creation
  Future<void> _initializeData() async {
    isLoading.value = true;
    await _fetchAllAppointments();
    isLoading.value = false;

    // Start periodic refresh after initial load
    _startPeriodicRefresh();
  }

  /// Start periodic refresh timer (every 30 seconds)
  void _startPeriodicRefresh() {
    // Cancel any existing timer to prevent duplicates
    _refreshTimer?.cancel();

    // Create new timer for background refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      // Only refresh if not already refreshing or loading
      if (!isRefreshing.value && !isLoading.value) {
        await _fetchAllAppointments(silent: true);
      }
    });
  }

  /// Fetch all appointments (upcoming, completed, cancelled)
  Future<void> _fetchAllAppointments({bool silent = false}) async {
    if (!silent) {
      isRefreshing.value = true;
    }

    // Fetch all lists in parallel for better performance
    await Future.wait([
      getUpcomingList(),
      getCompleteList(),
      getCancelList(),
    ]);

    if (!silent) {
      isRefreshing.value = false;
    }
    increment();
  }

  @override
  void onClose() {
    // Cancel timer to prevent memory leaks
    _refreshTimer?.cancel();
    super.onClose();
  }

  /// Increment counter to trigger UI rebuild
  void increment() => count.value++;

  /// Get upcoming/pending appointments
  Future<void> getUpcomingList() async {
    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.mentorId: LocalData.userId,
        ApiKeyConstants.type: LocalData.userType,
        ApiKeyConstants.status: 'Pending',
      };

      GetAppointmentListModel? getAppointmentListModel =
      await ApiMethods.getMyAppointmentApi(bodyParams: bodyParam);

      if (getAppointmentListModel != null &&
          getAppointmentListModel.status == '1') {
        upcomingList = getAppointmentListModel.result ?? [];
        debugPrint("✅ Get upcoming appointments: ${upcomingList.length} items");
      } else {
        upcomingList = [];
        debugPrint('❌ Get upcoming appointments failed');
      }
    } catch (e) {
      upcomingList = [];
      debugPrint('❌ Error fetching upcoming appointments: $e');
    }
  }

  /// Get cancelled appointments
  Future<void> getCancelList() async {
    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.mentorId: LocalData.userId,
        ApiKeyConstants.type: LocalData.userType,
        ApiKeyConstants.status: 'Cancel',
      };

      GetAppointmentListModel? getAppointmentListModel =
      await ApiMethods.getMyAppointmentApi(bodyParams: bodyParam);

      if (getAppointmentListModel != null &&
          getAppointmentListModel.status == '1') {
        cancelledList = getAppointmentListModel.result ?? [];
        debugPrint("✅ Get cancelled appointments: ${cancelledList.length} items");
      } else {
        cancelledList = [];
        debugPrint('❌ Get cancelled appointments failed');
      }
    } catch (e) {
      cancelledList = [];
      debugPrint('❌ Error fetching cancelled appointments: $e');
    }
  }

  /// Get completed appointments
  Future<void> getCompleteList() async {
    try {
      Map<String, dynamic> bodyParam = {
        ApiKeyConstants.mentorId: LocalData.userId,
        ApiKeyConstants.type: LocalData.userType,
        ApiKeyConstants.status: 'Complete',
      };

      GetAppointmentListModel? getAppointmentListModel =
      await ApiMethods.getMyAppointmentApi(bodyParams: bodyParam);

      if (getAppointmentListModel != null &&
          getAppointmentListModel.status == '1') {
        completedList = getAppointmentListModel.result ?? [];
        debugPrint("✅ Get completed appointments: ${completedList.length} items");
      } else {
        completedList = [];
        debugPrint('❌ Get completed appointments failed');
      }
    } catch (e) {
      completedList = [];
      debugPrint('❌ Error fetching completed appointments: $e');
    }
  }

  /// Call chat API to get token for messaging
  Future<void> chatApiCall(int index) async {
    try {
      if (index >= upcomingList.length) {
        debugPrint('❌ Invalid index for chatApiCall');
        return;
      }

      Map<String, dynamic> bodyParam = {
        "sender_id": LocalData.userId,
        "receiver_id": upcomingList[index].mentorDetails?.id,
        "appointment_id": upcomingList[index].id,
      };

      ChatTokenModel? chatTokenModel =
      await ApiMethods.chatApi(bodyParams: bodyParam);

      if (chatTokenModel != null && chatTokenModel.status == '1') {
        chatTokenResult = chatTokenModel.result;
        debugPrint('✅ Chat token retrieved successfully');
      } else {
        chatTokenResult = null;
        debugPrint('❌ Chat API failed');
        CommonWidgets.showMyToastMessage(
            chatTokenModel?.message ?? 'Failed to start chat');
      }
    } catch (e) {
      chatTokenResult = null;
      debugPrint('❌ Error calling chat API: $e');
      CommonWidgets.showMyToastMessage('Failed to start chat. Please try again.');
    }
  }

  /// Public method to refresh all appointments (used by RefreshIndicator)
  Future<void> refreshAll() async {
    await _fetchAllAppointments();
  }
}