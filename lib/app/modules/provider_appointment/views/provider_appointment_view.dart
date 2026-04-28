import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/app/modules/chat_mentor_screen.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_methods.dart';
import '../../../routes/app_pages.dart';
import '../../call_screen.dart';
import '../../video_call_screen.dart';
import '../controllers/provider_appointment_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/app/modules/chat_mentor_screen.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_methods.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../call_screen.dart';
import '../../video_call_screen.dart';
import '../controllers/provider_appointment_controller.dart';

// 1. Make it StatefulWidget instead of GetView
class ProviderAppointmentView extends StatefulWidget {
  const ProviderAppointmentView({Key? key}) : super(key: key);

  @override
  State<ProviderAppointmentView> createState() => _ProviderAppointmentViewState();
}

class _ProviderAppointmentViewState extends State<ProviderAppointmentView> with RouteAware {

  // Get controller manually since we're not using GetView anymore
  final controller = Get.find<ProviderAppointmentController>();

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

  // ✅ Screen first opened
  @override
  void didPush() {
    controller.onScreenResume();
  }

  // ✅ Came back from another screen (e.g. back from detail screen)
  @override
  void didPopNext() {
    controller.onScreenResume();
  }

  // ✅ Navigated away to another screen
  @override
  void didPushNext() {
    controller.onScreenPause();
  }

  // ✅ This screen is being closed/popped
  @override
  void didPop() {
    controller.onScreenPause();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primary3Color,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Mentoring Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: "Poppins",
                  ),
                ),
                Text(
                  'Track your appointments',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: Obx(() {
        controller.count.value;
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Enhanced TabBar
              Container(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
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
                      fontSize: 14.0,
                      fontFamily: "Poppins",
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      fontFamily: "Poppins",
                    ),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    controller.isLoading.value
                        ? shimmerView(width, height)
                        : upComingAppointment(width, height),
                    controller.isLoading.value
                        ? shimmerView(width, height)
                        : completedAppointment(width, height),
                    controller.isLoading.value
                        ? shimmerView(width, height)
                        : canceledAppointment(width, height)
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget upComingAppointment(double width, double height) {
    return RefreshIndicator(
      key: controller.refreshIndicatorKey1,
      color: primaryColor,
      onRefresh: () async {
        controller.getUpcomingList();
        controller.getCompleteList();
        controller.getCancelList();
      },
      child: controller.upcomingList.isEmpty
          ? _buildEmptyState('No Upcoming Appointments', Icons.calendar_today_outlined)
          : ListView.builder(
        itemCount: controller.upcomingList.length,
        padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
        itemBuilder: (BuildContext ctx, index) {
          final appointment = controller.upcomingList[index];

          DateTime appointmentDate =
              DateTime.tryParse(appointment.appointmentDate ?? '') ??
                  DateTime(2000);
          DateTime now = DateTime.now();

          DateTime expiryDate = DateTime(appointmentDate.year,
              appointmentDate.month, appointmentDate.day)
              .add(Duration(days: 1));

          bool isExpired = now.isAfter(expiryDate);
          bool canPerformAction = !isExpired && appointment.status == "Accept";

          return _buildAppointmentCard(
            appointment: appointment,
            isExpired: isExpired,
            canPerformAction: canPerformAction,
            index: index,
            onTap: () {
              if (!isExpired) {
                Get.toNamed(Routes.MENTOR_APPOINTMENT_DETAILS,
                    arguments: appointment);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard({
    required dynamic appointment,
    required bool isExpired,
    required bool canPerformAction,
    required int index,
    VoidCallback? onTap,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16.px),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with Status Badge
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
                        width: 75,
                        height: 75,
                        imageUrl: appointment.userDetails?.image ??
                            "https://picsum.photos/200/300",
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
                          child: Icon(Icons.person, color: Colors.grey[400], size: 35),
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
              SizedBox(width: 14.px),
              // Appointment Details
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
                              await _handleAppointmentAction(appointment, index);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(10.px),
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
                      Icons.category_outlined,
                      appointment.packageId ?? "N/A",
                      Colors.grey[600]!,
                    ),
                    SizedBox(height: 6.px),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      CommonMethods.formatDate(appointment.appointmentDate),
                      Colors.grey[600]!,
                    ),
                    SizedBox(height: 6.px),
                    _buildInfoRow(
                      Icons.access_time_outlined,
                      appointment.time ?? "",
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
      ),
    );
  }

  Widget completedAppointment(double width, double height) {
    return controller.isLoading.value
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : controller.completedList.isEmpty
        ? _buildEmptyState('No Completed Appointments', Icons.check_circle_outline)
        : RefreshIndicator(
      key: controller.refreshIndicatorKey2,
      color: primaryColor,
      onRefresh: () async {
        controller.getUpcomingList();
        controller.getCompleteList();
        controller.getCancelList();
      },
      child: ListView.builder(
        itemCount: controller.completedList.length,
        padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
        itemBuilder: (BuildContext ctx, index) {
          final appointment = controller.completedList[index];
          return _buildCompletedCard(appointment);
        },
      ),
    );
  }

  Widget _buildCompletedCard(dynamic appointment) {
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
                    border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      width: 75,
                      height: 75,
                      imageUrl: appointment.userDetails?.image ??
                          "https://picsum.photos/200/300",
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
                        child: Icon(Icons.person, color: Colors.grey[400], size: 35),
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
                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.px),
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
                      Container(
                        padding: EdgeInsets.all(8.px),
                        decoration: BoxDecoration(
                          color: _getPackageColor(appointment.packageId)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _getPackageIcon(appointment.packageId),
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
                    Icons.category_outlined,
                    appointment.packageId ?? "N/A",
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    CommonMethods.formatDate(appointment.appointmentDate),
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    appointment.time ?? "",
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 10.px),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
                        SizedBox(width: 4),
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

  Widget canceledAppointment(double width, double height) {
    return RefreshIndicator(
      key: controller.refreshIndicatorKey3,
      color: primaryColor,
      onRefresh: () async {
        controller.getUpcomingList();
        controller.getCompleteList();
        controller.getCancelList();
      },
      child: controller.cancelledList.isEmpty
          ? _buildEmptyState('No Cancelled Appointments', Icons.cancel_outlined)
          : ListView.builder(
        itemCount: controller.cancelledList.length,
        padding: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 100.px),
        itemBuilder: (BuildContext ctx, index) {
          final appointment = controller.cancelledList[index];
          return _buildCancelledCard(appointment);
        },
      ),
    );
  }

  Widget _buildCancelledCard(dynamic appointment) {
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
                    border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.5),
                        BlendMode.saturation,
                      ),
                      child: CachedNetworkImage(
                        width: 75,
                        height: 75,
                        imageUrl: appointment.userDetails?.image ??
                            "https://picsum.photos/200/300",
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
                          child: Icon(Icons.person, color: Colors.grey[400], size: 35),
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
                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.px),
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
                      Container(
                        padding: EdgeInsets.all(8.px),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _getPackageIcon(appointment.packageId),
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
                    Icons.category_outlined,
                    appointment.packageId ?? "N/A",
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    CommonMethods.formatDate(appointment.appointmentDate),
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 6.px),
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    appointment.time ?? "",
                    Colors.grey[600]!,
                  ),
                  SizedBox(height: 10.px),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 6.px),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel, size: 14, color: Colors.red.shade700),
                        SizedBox(width: 4),
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

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 6),
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

  Widget _buildStatusChip(dynamic appointment, bool isExpired) {
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
      text = 'Accepted';
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
          SizedBox(width: 4),
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

  Future<void> _handleAppointmentAction(dynamic appointment, int index) async {
    if (appointment.packageId == "Messaging") {
      await controller.chatApiCall(index);
      if (controller.chatTokenResult == null) {
        CommonWidgets.showMyToastMessage("Unable to start chat");
        return;
      }
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => ChatMentorScreen(
            appointmentListResult: appointment,
            token: controller.chatTokenResult!.token!,
            receiverId: controller.chatTokenResult!.receiverId!,
            status: 'message',
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
            channelName: controller.addVideoConnectionResult!.channelName!,
          )
              : VideoCallScreen(
            appointmentListResult: appointment,
            token: controller.addVideoConnectionResult!.token!,
            channelName: controller.addVideoConnectionResult!.channelName!,
          ),
        ),
      );

      controller.getUpcomingList();
      controller.getCompleteList();
      controller.getCancelList();
    }
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
            child: Icon(
              icon,
              size: 60,
              color: primaryColor.withOpacity(0.6),
            ),
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
    final size = 20.0;
    switch (packageId) {
      case "Messaging":
        return Icon(Icons.chat_bubble_rounded, size: size, color: Colors.blue);
      case "Voice call":
        return Icon(Icons.phone_rounded, size: size, color: Colors.green);
      case "Video call":
        return Icon(Icons.videocam_rounded, size: size, color: Colors.purple);
      default:
        return Icon(Icons.help_outline, size: size, color: Colors.grey);
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

  Widget shimmerView(double width, double height) {
    return CommonWidgets.commonShimmer(
        shimmerWidget: ListView.builder(
            itemCount: 6,
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.px),
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                width: width,
                height: height * 0.15,
                margin: EdgeInsets.all(2.px),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(color: Colors.black54, width: 1.px)),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.all(5.px),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5.px)),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 20,
                            margin: EdgeInsets.all(2.px),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(3.px)),
                          ),
                          Container(
                            width: 60,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(3.px)),
                          ),
                          Container(
                            width: 90,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(3.px)),
                          ),
                          Container(
                            width: 60,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(3.px)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.all(2.px),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5.px)),
                    ),
                  ],
                ),
              );
            }));
  }
}


