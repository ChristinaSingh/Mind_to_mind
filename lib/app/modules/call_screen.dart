import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/colors.dart';
import '../../common/common_widgets.dart';
import '../../common/local_data.dart';
import '../data/apis/api_constants/api_key_constants.dart';
import '../data/apis/api_methods/api_methods.dart';
import '../data/apis/api_models/get_appointmentlist_model.dart';
import '../data/apis/api_models/get_update_status_model.dart';

class CallScreen extends StatefulWidget {
  final GetAppointmentListResult appointmentListResult;
  final String token;
  final String channelName;

  const CallScreen(
      {super.key,
      required this.appointmentListResult,
      required this.token,
      required this.channelName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;

  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Permissions
    await [Permission.microphone, Permission.camera].request();

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: "78d0ddb8da264ed69395598a3cb3c73d",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
          _engine.setEnableSpeakerphone(true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Dispose resources
  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Toggle Mute
  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  // Leave Call
  void _onCallEnd(BuildContext context) async {
    await _dispose();
    Navigator.pop(context);
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.appointmentListResult.userDetails!.image ??
                      "https://picsum.photos/200/300",
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            _buildTopBar(context),
            _buildBottomBar(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return InkWell(
      onTap: () {
        showCancelDialog(context, "Complete", widget.appointmentListResult.id!);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Close session",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }

  // Bottom Bar
  Widget _buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute Button
            IconButton(
              onPressed: _onToggleMute,
              icon: Icon(
                _muted ? Icons.mic_off : Icons.mic,
                color: _muted ? Colors.red : Colors.white,
              ),
              tooltip: _muted ? "Unmute" : "Mute",
            ),
            // End Call Button
            IconButton(
              onPressed: () => _onCallEnd(context),
              icon: const Icon(Icons.call_end, color: Colors.red),
              tooltip: "End Call",
            ),
          ],
        ),
      ),
    );
  }

  // Remote Video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(
              channelId: widget.appointmentListResult.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  void showCancelDialog(BuildContext context, String status, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$status Booking",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to $status the booking?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Yes",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                updateStatus(status, id);
                Get.back();
              },
            ),
          ],
        );
      },
    );
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
      await _dispose();
      Navigator.pop(context);
    } else {
      print('Update status failed.....');
      CommonWidgets.showMyToastMessage(
          updateStatusModel?.message ?? 'Update status  failed.....');
    }
  }
}
