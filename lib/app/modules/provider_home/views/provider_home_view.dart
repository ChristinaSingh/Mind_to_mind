import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_methods.dart';
import '../../../../common/common_widgets.dart';
import '../../../../common/local_data.dart';
import '../../../../main.dart';
import '../../../data/apis/api_models/get_appointmentlist_model.dart';
import '../../call_screen.dart';
import '../../chat_mentor_screen.dart';
import '../../video_call_screen.dart';
import '../controllers/provider_home_controller.dart';

class ProviderHomeView extends StatefulWidget {
  const ProviderHomeView({Key? key}) : super(key: key);

  @override
  State<ProviderHomeView> createState() => _ProviderHomeViewState();
}

class _ProviderHomeViewState extends State<ProviderHomeView> with RouteAware {
  final controller = Get.find<ProviderHomeController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() => controller.onScreenResume();

  @override
  void didPopNext() => controller.onScreenResume();

  @override
  void didPushNext() => controller.onScreenPause();

  @override
  void didPop() => controller.onScreenPause();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primary3Color,
      body: Obx(() {
        controller.count.value;
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.px, vertical: 10.px),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appointments',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              Text(
                                'Manage your bookings',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                          if (LocalData.userType == 'Both')
                            GestureDetector(
                              onTap: () => controller.showAlertDialog(context),
                              child: Container(
                                padding: EdgeInsets.all(12.px),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/ic_both.svg",
                                  height: 24.px,
                                  width: 24.px,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.px, vertical: 5.px),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        physics: const NeverScrollableScrollPhysics(),
                        labelPadding: EdgeInsets.symmetric(vertical: 6.px),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[700],
                        isScrollable: false,
                        indicator: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0,
                          fontFamily: "Poppins",
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          fontFamily: "Poppins",
                        ),
                        onTap: (value) => controller.changeTabIndex(value),
                        tabs: const [
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Completed'),
                          Tab(text: 'Cancelled'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    upcomingView(width, height),
                    completedView(width, height),
                    canceledView(width, height),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ✅ Smart expiry: uses end_time for new bookings, time for old ones
  DateTime getAppointmentDateTime(GetAppointmentListResult appointment) {
    try {
      // New bookings have end_time "2026-03-21 17:00:00"
      if (appointment.endTime != null && appointment.endTime!.isNotEmpty) {
        return DateTime.parse(appointment.endTime!);
      }
      // Old bookings have time "15:00" with appointmentDate
      final date = appointment.appointmentDate;
      final time = appointment.time;
      if (date != null && time != null && time.isNotEmpty) {
        if (time.contains("AM") || time.contains("PM")) {
          final format = DateFormat.jm();
          final parsedTime = format.parse(time);
          final converted = DateFormat("HH:mm").format(parsedTime);
          return DateTime.parse("$date $converted:00");
        } else {
          return DateTime.parse("$date $time:00");
        }
      }
    } catch (e) {
      print("Date parse error: $e");
    }
    return DateTime(2000);
  }

  // ✅ Smart time display: range for new, single time for old
  String _getDisplayTime(GetAppointmentListResult appointment) {
    // ✅ New bookings: extract "09:00" from "2026-03-22 09:00:00"
    if (appointment.startTime != null &&
        appointment.startTime!.isNotEmpty &&
        appointment.endTime != null &&
        appointment.endTime!.isNotEmpty) {
      return '${appointment.startTimeOnly} → ${appointment.endTimeOnly}';
    }
    // ✅ Old bookings: use time field "15:00"
    if (appointment.time != null && appointment.time!.isNotEmpty) {
      return appointment.time!;
    }
    return 'N/A';
  }

  Widget upcomingView(double width, double height) {
    return controller.isLoading.value
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : controller.upcomingList.isEmpty
            ? _buildEmptyState(
                'No Upcoming Appointments', Icons.calendar_today_outlined)
            : RefreshIndicator(
                key: controller.refreshIndicatorKey4,
                color: primaryColor,
                onRefresh: () async {
                  await controller.getUpcomingList();
                  await controller.getCompleteList();
                  await controller.getCancelList();
                },
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
                  itemCount: controller.upcomingList.length,
                  itemBuilder: (context, index) {
                    final appointment = controller.upcomingList[index];

                    // ✅ Uses end_time or time depending on booking type
                    final appointmentDateTime =
                        getAppointmentDateTime(appointment);

                    // ✅ 1 hour grace period after end time
                    final isExpired = DateTime.now().isAfter(
                      appointmentDateTime.add(const Duration(hours: 1)),
                    );

                    final canPerformAction =
                        !isExpired && appointment.status == "Accept";

                    return _buildAppointmentCard(
                      width: width,
                      height: height,
                      appointment: appointment,
                      isExpired: isExpired,
                      canPerformAction: canPerformAction,
                      index: index,
                      showActions:
                          !isExpired && appointment.status == "Pending",
                    );
                  },
                ),
              );
  }

  Widget _buildAppointmentCard({
    required double width,
    required double height,
    required GetAppointmentListResult appointment,
    required bool isExpired,
    required bool canPerformAction,
    required int index,
    bool showActions = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired ? Colors.grey.shade300 : Colors.transparent,
          width: 1,
        ),
        boxShadow: isExpired
            ? []
            : [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.px),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          width: 70,
                          height: 70,
                          imageUrl: appointment.userDetails?.image ??
                              "https://picsum.photos/200",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.person,
                                color: Colors.grey[400], size: 35),
                          ),
                        ),
                      ),
                    ),
                    if (!isExpired)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.px),
                          decoration: BoxDecoration(
                            color: appointment.status == "Accept"
                                ? Colors.green
                                : Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            appointment.status == "Accept"
                                ? Icons.check
                                : Icons.access_time,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appointment.userDetails?.name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontFamily: "Poppins",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (canPerformAction)
                            InkWell(
                              onTap: () async {
                                await _handleAppointmentAction(
                                    appointment, index);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(8.px),
                                decoration: BoxDecoration(
                                  color: _getPackageColor(appointment.packageId)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _getPackageIcon(appointment.packageId),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.px),
                      _buildInfoRow(
                        Icons.fingerprint_outlined,
                        "ID: ${appointment.id}",
                        Colors.grey[600]!,
                      ),
                      SizedBox(height: 6.px),
                      _buildInfoRow(
                        Icons.category,
                        "${appointment.packageId}",
                        Colors.grey[600]!,
                      ),
                      SizedBox(height: 6.px),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        CommonMethods.formatDate(appointment.appointmentDate),
                        Colors.grey[600]!,
                      ),
                      SizedBox(height: 6.px),
                      // ✅ Smart time display
                      _buildInfoRow(
                        Icons.access_time_outlined,
                        _getDisplayTime(appointment),
                        Colors.grey[600]!,
                      ),
                      SizedBox(height: 10.px),
                      _buildStatusChip(appointment, isExpired),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showActions)
            Container(
              padding: EdgeInsets.fromLTRB(16.px, 0, 16.px, 16.px),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Decline',
                      color: Colors.red,
                      icon: Icons.close_rounded,
                      onTap: () => controller.showCancelDialog(
                          Get.context!, "Cancel", appointment.id!),
                    ),
                  ),
                  SizedBox(width: 12.px),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Accept',
                      color: primaryColor,
                      icon: Icons.check_rounded,
                      onTap: () => controller.showCancelDialog(
                          Get.context!, "Accept", appointment.id!),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
              fontFamily: "Poppins",
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(
      GetAppointmentListResult appointment, bool isExpired) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    if (isExpired) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
      text = 'Expired';
      icon = Icons.event_busy_rounded;
    } else if (appointment.status == "Accept") {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
      text = 'Scheduled';
      icon = Icons.event_available_rounded;
    } else {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
      text = 'Pending';
      icon = Icons.pending_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.px),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAppointmentAction(
      GetAppointmentListResult appointment, int index) async {
    if (appointment.packageId == "Messaging") {
      await controller.chatApiCall(index);
      if (controller.chatTokenResult == null) {
        CommonWidgets.showMyToastMessage("Unable to start chat");
        return;
      }
      print("Chat time: ${appointment.time}");
      print("Chat startTime: ${appointment.startTime}");
      print("Chat endTime: ${appointment.endTime}");
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => ChatMentorScreen(
            appointmentListResult: appointment,
            token: controller.chatTokenResult!.token!,
            receiverId: controller.chatTokenResult!.receiverId!,
            status: 'ongoing',
          ),
        ),
      );
    } else if (appointment.packageId == "Voice call" ||
        appointment.packageId == "Video call") {
      if (appointment.channelName == null || appointment.channelName!.isEmpty) {
        await controller.addVideoConnection(index);
      }
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => appointment.packageId == "Voice call"
              ? CallScreen(
                  appointmentListResult: appointment,
                  token: controller.addVideoConnectionResult!.token!,
                  channelName:
                      controller.addVideoConnectionResult!.channelName!,
                )
              : VideoCallScreen(
                  appointmentListResult: appointment,
                  token: controller.addVideoConnectionResult!.token!,
                  channelName:
                      controller.addVideoConnectionResult!.channelName!,
                ),
        ),
      );
      controller.getUpcomingList();
      controller.getCompleteList();
      controller.getCancelList();
    }
  }

  Widget completedView(double width, double height) {
    return controller.isLoading.value
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : controller.completeList.isEmpty
            ? _buildEmptyState(
                'No Completed Appointments', Icons.check_circle_outline)
            : RefreshIndicator(
                key: controller.refreshIndicatorKey5,
                color: primaryColor,
                onRefresh: () async {
                  await controller.getUpcomingList();
                  await controller.getCompleteList();
                  await controller.getCancelList();
                },
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
                  itemCount: controller.completeList.length,
                  itemBuilder: (context, index) {
                    final appointment = controller.completeList[index];
                    return _buildCompletedCard(
                        width, height, appointment, index);
                  },
                ),
              );
  }

  Widget _buildCompletedCard(double width, double height,
      GetAppointmentListResult appointment, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      width: 70,
                      height: 70,
                      imageUrl: appointment.userDetails?.image ??
                          "https://picsum.photos/200",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.px),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.userDetails?.name ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 8.px),
                  _buildInfoRow(Icons.fingerprint_outlined,
                      "ID: ${appointment.id}", Colors.grey[600]!),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                      Icons.calendar_today_outlined,
                      CommonMethods.formatDate(appointment.appointmentDate),
                      Colors.grey[600]!),
                  SizedBox(height: 6.px),
                  // ✅ Smart time display
                  _buildInfoRow(Icons.access_time_outlined,
                      _getDisplayTime(appointment), Colors.grey[600]!),
                  SizedBox(height: 10.px),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget canceledView(double width, double height) {
    return controller.isLoading.value
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : controller.cancelList.isEmpty
            ? _buildEmptyState(
                'No Cancelled Appointments', Icons.cancel_outlined)
            : RefreshIndicator(
                key: controller.refreshIndicatorKey6,
                color: primaryColor,
                onRefresh: () async {
                  await controller.getUpcomingList();
                  await controller.getCompleteList();
                  await controller.getCancelList();
                },
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
                  itemCount: controller.cancelList.length,
                  itemBuilder: (context, index) {
                    final appointment = controller.cancelList[index];
                    return _buildCancelledCard(
                        width, height, appointment, index);
                  },
                ),
              );
  }

  Widget _buildCancelledCard(double width, double height,
      GetAppointmentListResult appointment, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.red.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.5),
                        BlendMode.saturation,
                      ),
                      child: CachedNetworkImage(
                        width: 70,
                        height: 70,
                        imageUrl: appointment.userDetails?.image ??
                            "https://picsum.photos/200",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.px),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.userDetails?.name ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 8.px),
                  _buildInfoRow(Icons.fingerprint_outlined,
                      "ID: ${appointment.id}", Colors.grey[600]!),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                      Icons.calendar_today_outlined,
                      CommonMethods.formatDate(appointment.appointmentDate),
                      Colors.grey[600]!),
                  SizedBox(height: 6.px),
                  // ✅ Smart time display
                  _buildInfoRow(Icons.access_time_outlined,
                      _getDisplayTime(appointment), Colors.grey[600]!),
                  SizedBox(height: 10.px),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel,
                            size: 14, color: Colors.red.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Cancelled',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.px),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 60, color: primaryColor.withOpacity(0.6)),
          ),
          SizedBox(height: 20.px),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPackageIcon(String? packageId) {
    const double size = 20.0;
    switch (packageId) {
      case "Messaging":
        return const Icon(Icons.chat_bubble_rounded,
            size: size, color: Colors.blue);
      case "Voice call":
        return const Icon(Icons.phone_rounded, size: size, color: Colors.green);
      case "Video call":
        return const Icon(Icons.videocam_rounded,
            size: size, color: Colors.purple);
      default:
        return const Icon(Icons.help_outline, size: size, color: Colors.grey);
    }
  }

  Color _getPackageColor(String? packageId) {
    switch (packageId) {
      case "Messaging":
        return Colors.blue;
      case "Voice call":
        return Colors.green;
      case "Video call":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
