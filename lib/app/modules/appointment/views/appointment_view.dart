// ════════════════════════════════════════════════════════════════════════════
//  appointment_view.dart  — FIXED: status: 'ongoing' passed to MenteeChatScreen
// ════════════════════════════════════════════════════════════════════════════

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindtomind/app/modules/mentee_audio_call_screen.dart';
import 'package:mindtomind/app/modules/mentee_chat_screen.dart';
import 'package:mindtomind/app/modules/mentee_video_call_screen.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_methods.dart';
import '../../../data/apis/api_models/get_appointmentlist_model.dart';
import '../controllers/appointment_controller.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonWidgets.appBar(
        title: 'My Mentoring Sessions',
        centerTitle: false,
        wantBackButton: false,
      ),
      body: Obx(() {
        controller.count.value;
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  labelColor: primaryColor,
                  unselectedLabelColor: labelColor,
                  isScrollable: false,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    fontFamily: "Poppins",
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.2,
                    fontFamily: "Poppins",
                  ),
                  tabs: const [
                    Tab(text: 'Pending/Upcoming'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabContent(
                      isLoading: controller.isLoading.value,
                      child: upComingAppointment(),
                    ),
                    _buildTabContent(
                      isLoading: controller.isLoading.value,
                      child: completedAppointment(),
                    ),
                    _buildTabContent(
                      isLoading: controller.isLoading.value,
                      child: canceledAppointment(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabContent({required bool isLoading, required Widget child}) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
            const SizedBox(height: 16),
            Text('Loading appointments...',
                style: TextStyle(color: labelColor, fontSize: 14, fontFamily: "Poppins")),
          ],
        ),
      );
    }
    return child;
  }

  Widget upComingAppointment() {
    return RefreshIndicator(
      key: controller.refreshIndicatorKey1,
      color: primaryColor,
      onRefresh: controller.refreshAll,
      child: controller.upcomingList.isEmpty
          ? _buildEmptyState(
        icon: Icons.calendar_today_outlined,
        message: 'No Pending Appointments',
        subtitle: 'Your upcoming sessions will appear here',
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: controller.upcomingList.length,
        itemBuilder: (context, index) {
          final appointment = controller.upcomingList[index];

          // ✅ Pass full appointment object
          final appointmentDateTime = getAppointmentDateTime(appointment);

          final isExpired = DateTime.now().isAfter(
            appointmentDateTime.add(const Duration(hours: 1)),
          );

          return _buildAppointmentCard(
            appointment: appointment,
            isExpired: isExpired,
            onTap: isExpired || appointment.status != "Accept"
                ? null
                : () => _handleMenteeNavigation(index, appointment),
            statusWidget: isExpired
                ? _buildStatusChip("Expired", Colors.red)
                : appointment.status == "Accept"
                ? _buildStatusChip("Accepted", Colors.green)
                : _buildStatusChip("Pending", Colors.orange),
            trailingIcon: isExpired || appointment.status != "Accept"
                ? null
                : _getTrailingIcon(appointment.packageId),
          );
        },
      ),
    );
  }

  Widget completedAppointment() {
    return RefreshIndicator(
      key: controller.refreshIndicatorKey2,
      color: primaryColor,
      onRefresh: controller.refreshAll,
      child: controller.completedList.isEmpty
          ? _buildEmptyState(
        icon: Icons.check_circle_outline,
        message: 'No Completed Appointments',
        subtitle: 'Your completed sessions will appear here',
      )
          : ListView.builder(
        itemCount: controller.completedList.length,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemBuilder: (context, index) {
          final appointment = controller.completedList[index];
          return _buildAppointmentCard(
            appointment: appointment,
            statusWidget: _buildStatusChip("Completed", Colors.green),
          );
        },
      ),
    );
  }

  Widget canceledAppointment() {
    return RefreshIndicator(
      key: controller.refreshIndicatorKey3,
      color: primaryColor,
      onRefresh: controller.refreshAll,
      child: controller.cancelledList.isEmpty
          ? _buildEmptyState(
        icon: Icons.cancel_outlined,
        message: 'No Cancelled Appointments',
        subtitle: 'Your cancelled sessions will appear here',
      )
          : ListView.builder(
        itemCount: controller.cancelledList.length,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemBuilder: (context, index) {
          final appointment = controller.cancelledList[index];
          return _buildAppointmentCard(
            appointment: appointment,
            statusWidget: _buildStatusChip("Cancelled", Colors.redAccent),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String subtitle,
  }) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: primaryColor),
              ),
              const SizedBox(height: 24),
              Text(message,
                  style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A), fontFamily: "Poppins",
                  )),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, color: labelColor, fontFamily: "Poppins",
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required GetAppointmentListResult appointment,
    bool isExpired = false,
    VoidCallback? onTap,
    Widget? statusWidget,
    Widget? trailingIcon,
  }) {
    return AnimatedOpacity(
      opacity: isExpired ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpired
                ? Colors.grey.withOpacity(0.2)
                : primaryColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: isExpired
              ? []
              : [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mentor Image
                  Hero(
                    tag: 'mentor_${appointment.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          width: 72, height: 72,
                          imageUrl: appointment.mentorDetails?.image ??
                              "https://picsum.photos/200",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: primaryColor.withOpacity(0.1),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor, strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: primaryColor.withOpacity(0.1),
                            child: const Icon(Icons.person,
                                color: primaryColor, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.mentorDetails?.name ?? "Unknown Mentor",
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A), fontFamily: "Poppins",
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        _buildInfoRow(
                          Icons.event_outlined,
                          "${CommonMethods.formatDate(appointment.appointmentDate)} • ${appointment.timeRange}",
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(Icons.tag_outlined, "ID: ${appointment.id}"),
                        const SizedBox(height: 8),
                        if (statusWidget != null) statusWidget,
                      ],
                    ),
                  ),
                  // Trailing Icon
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: trailingIcon,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: labelColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13, color: labelColor,
              fontFamily: "Poppins", fontWeight: FontWeight.w500,
            ),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(text,
          style: TextStyle(
            color: color, fontWeight: FontWeight.w600,
            fontSize: 12, fontFamily: "Poppins",
          )),
    );
  }

  Future<void> _handleMenteeNavigation(
      int index,
      GetAppointmentListResult appointment,
      ) async {
    try {
      if (appointment.status == "Pending") {
        CommonWidgets.showMyToastMessage('This appointment is currently pending');
        return;
      }

      if (appointment.packageId == "Messaging") {
        await controller.chatApiCall(index);

        if (controller.chatTokenResult == null) {
          CommonWidgets.showMyToastMessage('Unable to start chat. Please try again.');
          return;
        }

        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => MenteeChatScreen(
              appointmentListResult: appointment,
              token: controller.chatTokenResult!.token!,
              receiverId: controller.chatTokenResult!.receiverId!,
              // ✅ FIX: was 'message' — must be 'ongoing' so _ChatPhase
              //    evaluates correctly and the send panel is shown
              status: 'ongoing',
            ),
          ),
        );
        return;
      }
      //
      // if (appointment.channelName == null || appointment.channelName!.isEmpty) {
      //   CommonWidgets.snackBarView(title: 'Mentor has not come live yet');
      //   return;
      // }

      if (appointment.packageId == "Voice call") {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) =>
                MenteeAudioCallScreen(appointmentListResult: appointment),
          ),
        );
        return;
      }

      if (appointment.packageId == "Video call") {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) =>
                MenteeVideoCallScreen(appointmentListResult: appointment),
          ),
        );
        return;
      }

      CommonWidgets.showMyToastMessage('Unable to open appointment');
    } catch (e) {
      debugPrint("Navigation Error: $e");
      CommonWidgets.showMyToastMessage('Something went wrong. Please try again.');
    }
  }

  Widget _getTrailingIcon(String? packageId) {
    switch (packageId) {
      case "Messaging":
        return SvgPicture.asset("assets/images/ChatIcon.svg",
            width: 24, height: 24, color: primaryColor);
      case "Voice call":
        return SvgPicture.asset("assets/images/voiceCallIcon.svg",
            width: 24, height: 24, color: primaryColor);
      case "Video call":
        return SvgPicture.asset("assets/images/videoCallIcon.svg",
            width: 24, height: 24, color: primaryColor);
      default:
        return const SizedBox();
    }
  }

// ✅ REPLACE getAppointmentDateTime — now takes full appointment object
  DateTime getAppointmentDateTime(GetAppointmentListResult appointment) {
    try {
      // New bookings: use end_time "2026-03-22 09:30:00"
      if (appointment.endTime != null && appointment.endTime!.isNotEmpty) {
        return DateTime.parse(appointment.endTime!);
      }
      // Old bookings: use appointmentDate + time "15:00"
      final date = appointment.appointmentDate;
      final time = appointment.time;
      if (date != null && time != null && time.isNotEmpty) {
        final converted = _convertTo24Hour(time.trim());
        final timeWithSeconds =
        converted.length == 5 ? "$converted:00" : converted;
        return DateTime.parse("$date $timeWithSeconds");
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
    }
    return DateTime(2000);
  }


  String _convertTo24Hour(String time) {
    if (!time.contains("AM") && !time.contains("PM")) return time;
    try {
      final format = DateFormat("h:mm a");
      final dateTime = format.parse(time.toUpperCase());
      return DateFormat("HH:mm").format(dateTime);
    } catch (e) {
      debugPrint("Error converting time: $e");
      return time;
    }
  }
}