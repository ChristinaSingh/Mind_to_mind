import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/common_widgets.dart';
import 'package:mindtomind/common/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/common_methods.dart';
import '../../chat_mentor_screen.dart';
import '../../mentee_chat_screen.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonWidgets.appBar(
        title: 'History',
        centerTitle: false,
        wantBackButton: false,
      ),
      body: Obx(() {
        controller.count.value;

        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildMessageTab(),
                    _buildVoiceTab(),
                    _buildVideoTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
          const SizedBox(height: 16),
          Text('Loading history...', style: TextStyle(color: labelColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: TabBar(
        physics: const NeverScrollableScrollPhysics(),
        labelColor: primaryColor,
        unselectedLabelColor: labelColor,
        isScrollable: false,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: primaryColor),
        ),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 15,
          letterSpacing: 0.2, fontFamily: "Poppins",
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14,
          letterSpacing: 0.2, fontFamily: "Poppins",
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message, size: 13),
                const SizedBox(width: 6),
                const Text('Message', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                if (controller.messageList.isNotEmpty)
                  _buildCountBadge(controller.messageList.length),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call, size: 13),
                const SizedBox(width: 6),
                const Text('Voice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                if (controller.audioList.isNotEmpty)
                  _buildCountBadge(controller.audioList.length),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam, size: 13),
                const SizedBox(width: 6),
                const Text('Video', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                if (controller.videoList.isNotEmpty)
                  _buildCountBadge(controller.videoList.length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMessageTab() {
    if (controller.messageList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.message_outlined,
        title: 'No Message History',
        subtitle: 'Your message appointments will appear here',
      );
    }
    return RefreshIndicator(
      onRefresh: () async => await controller.getAllHistoryListApi(),
      color: primaryColor,
      child: ListView.builder(
        itemCount: controller.messageList.length,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemBuilder: (context, index) => _buildMessageCard(index),
      ),
    );
  }

  Widget _buildVoiceTab() {
    if (controller.audioList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.call_outlined,
        title: 'No Voice Call History',
        subtitle: 'Your voice call appointments will appear here',
      );
    }
    return RefreshIndicator(
      onRefresh: () async => await controller.getAllHistoryListApi(),
      color: primaryColor,
      child: ListView.builder(
        itemCount: controller.audioList.length,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemBuilder: (context, index) =>
            _buildAppointmentCard(controller.audioList[index], 'voice'),
      ),
    );
  }

  Widget _buildVideoTab() {
    if (controller.videoList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.videocam_outlined,
        title: 'No Video Call History',
        subtitle: 'Your video call appointments will appear here',
      );
    }
    return RefreshIndicator(
      onRefresh: () async => await controller.getAllHistoryListApi(),
      color: primaryColor,
      child: ListView.builder(
        itemCount: controller.videoList.length,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemBuilder: (context, index) =>
            _buildAppointmentCard(controller.videoList[index], 'video'),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: hintColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 64, color: hintColor),
            ),
            const SizedBox(height: 24),
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: labelColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: TextStyle(fontSize: 14, color: hintColor),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ── Message card — ALWAYS tappable, no status gate ────────────────────────

  Widget _buildMessageCard(int index) {
    final appointment = controller.messageList[index];
    final mentor = appointment.mentorDetails;
    final status = appointment.status ?? 'unknown';

    // ✅ Navigate to chat for ALL statuses — chat screen handles what's editable
    Future<void> openChat() async {
      await controller.chatApiCall(index);
      if (controller.chatTokenResult != null) {
        Get.to(() => MenteeChatScreen(
          notificationResult: appointment,
          token: controller.chatTokenResult!.token!,
          receiverId: controller.chatTokenResult!.receiverId!,
          status: status,
        ));
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: openChat,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.px),
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getStatusColor(status).withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Profile image
                _buildAvatar(mentor?.image),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mentor?.name ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: MyTextStyle.titleStyle16bb,
                            ),
                          ),
                          _buildStatusBadge(status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 14, color: labelColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mentor?.mobile ?? 'N/A',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: labelColor),
                            ),
                          ),
                        ],
                      ),
                      if (appointment.amount != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text('\$${appointment.amount}',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Appointment details
            _buildAppointmentInfo(
              date: CommonMethods.formatDate(appointment.appointmentDate),
              time: appointment.time ?? 'N/A',
              extra: appointment.packageId,
              extraIcon: Icons.message,
            ),

            const SizedBox(height: 12),

            // ✅ Button always shows "View Chat" — no lock state
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openChat,
                icon: const Icon(Icons.chat, size: 18),
                label: const Text(
                  'View Chat',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(appointment, String type) {
    final mentor = appointment.mentorDetails;
    final status = appointment.status ?? 'unknown';

    return Container(
      margin: EdgeInsets.only(bottom: 16.px),
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  _buildAvatar(mentor?.image),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle,
                        border: Border.all(color: backgroundColor, width: 2),
                      ),
                      child: Icon(
                        type == 'voice' ? Icons.call : Icons.videocam,
                        size: 14, color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(mentor?.name ?? 'Unknown',
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: MyTextStyle.titleStyle16bb),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: labelColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(mentor?.mobile ?? 'N/A',
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: labelColor)),
                        ),
                      ],
                    ),
                    if (appointment.amount != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text('\$${appointment.amount}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAppointmentInfo(
            date: CommonMethods.formatDate(appointment.appointmentDate),
            time: appointment.time ?? 'N/A',
            extra: appointment.packageId,
            extraIcon: type == 'voice' ? Icons.call : Icons.videocam,
          ),
        ],
      ),
    );
  }

  // ── Shared sub-widgets ────────────────────────────────────────────────────

  Widget _buildAvatar(String? imageUrl) {
    return Container(
      padding: EdgeInsets.all(3.px),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.6)]),
      ),
      child: Container(
        padding: EdgeInsets.all(2.px),
        decoration: const BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.px),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            fit: BoxFit.cover,
            height: 56.px, width: 56.px,
            placeholder: (_, __) => Container(
                color: hintColor.withOpacity(0.1),
                child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor))),
            errorWidget: (_, __, ___) => Container(
                color: hintColor.withOpacity(0.1),
                child: Icon(Icons.person, size: 30, color: hintColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentInfo({
    required String date,
    required String time,
    String? extra,
    required IconData extraIcon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: primaryDarkColor),
              const SizedBox(width: 8),
              Text(date,
                  style: TextStyle(fontSize: 13, color: primaryDarkColor, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.access_time, size: 16, color: primaryDarkColor),
              const SizedBox(width: 8),
              Text(time,
                  style: TextStyle(fontSize: 13, color: primaryDarkColor, fontWeight: FontWeight.w600)),
            ],
          ),
          if (extra != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(extraIcon, size: 16, color: primaryDarkColor),
                const SizedBox(width: 8),
                Text(extra,
                    style: TextStyle(fontSize: 13, color: primaryDarkColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusLower = status.toLowerCase();
    Color color;
    IconData icon;
    switch (statusLower) {
      case 'complete':   color = Colors.green;  icon = Icons.check_circle; break;
      case 'ongoing':    color = Colors.orange; icon = Icons.access_time;  break;
      case 'pending':    color = Colors.blue;   icon = Icons.schedule;     break;
      case 'cancelled':  color = Colors.red;    icon = Icons.cancel;       break;
      default:           color = hintColor;     icon = Icons.help_outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(status.capitalize ?? status,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'complete':  return Colors.green;
      case 'ongoing':   return Colors.orange;
      case 'pending':   return Colors.blue;
      case 'cancelled': return Colors.red;
      default:          return hintColor;
    }
  }
}