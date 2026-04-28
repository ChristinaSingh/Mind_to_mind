// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../common/colors.dart';
// import '../../common/common_widgets.dart';
// import '../../common/local_data.dart';
// import '../data/apis/api_constants/api_key_constants.dart';
// import '../data/apis/api_methods/api_methods.dart';
// import '../data/apis/api_models/get_appointmentlist_model.dart';
// import '../data/apis/api_models/get_update_status_model.dart';
//
// class VideoCallScreen extends StatefulWidget {
//   final GetAppointmentListResult appointmentListResult;
//   final String token;
//   final String channelName;
//
//   const VideoCallScreen(
//       {super.key,
//       required this.appointmentListResult,
//       required this.token,
//       required this.channelName});
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   bool _muted = false;
//   bool _cameraFront = true;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//
//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: "78d0ddb8da264ed69395598a3cb3c73d",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: widget.token,
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       _muted = !_muted;
//     });
//     _engine.muteLocalAudioStream(_muted);
//   }
//
//   // Switch Camera
//   void _onSwitchCamera() {
//     _engine.switchCamera();
//     setState(() {
//       _cameraFront = !_cameraFront;
//     });
//   }
//
//   // Leave Call
//   void _onCallEnd(BuildContext context) async {
//     await _dispose();
//     Navigator.pop(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(child: _remoteVideo()),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//           // Bottom Bar for Controls
//           _buildTopBar(context),
//           _buildBottomBar(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTopBar(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         showCancelDialog(context,"Complete",widget.appointmentListResult.id!);
//       },
//       child: Align(
//         alignment: Alignment.topRight,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.red.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Text(
//             "Close session",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomBar(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         color: Colors.black54,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Mute Button
//             IconButton(
//               onPressed: _onToggleMute,
//               icon: Icon(
//                 _muted ? Icons.mic_off : Icons.mic,
//                 color: _muted ? Colors.red : Colors.white,
//               ),
//               tooltip: _muted ? "Unmute" : "Mute",
//             ),
//             // End Call Button
//             IconButton(
//               onPressed: () => _onCallEnd(context),
//               icon: const Icon(Icons.call_end, color: Colors.red),
//               tooltip: "End Call",
//             ),
//             // Switch Camera Button
//             IconButton(
//               onPressed: _onSwitchCamera,
//               icon: const Icon(Icons.switch_camera, color: Colors.white),
//               tooltip: "Switch Camera",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//   void showCancelDialog(BuildContext context, String status, String id) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("$status Booking",
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//           content: Text("Are you sure you want to $status the booking?"),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("No",
//                   style: TextStyle(
//                       color: primaryColor, fontWeight: FontWeight.bold)),
//               onPressed: () {
//                 Get.back();
//               },
//             ),
//             TextButton(
//               child: const Text("Yes",
//                   style: TextStyle(
//                       color: primaryColor, fontWeight: FontWeight.bold)),
//               onPressed: () {
//                 updateStatus(status, id);
//                 Get.back();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void updateStatus(String status, String id) async {
//     Map<String, dynamic> bodyParam = {
//       ApiKeyConstants.status: status,
//       ApiKeyConstants.appointmentId: id,
//       ApiKeyConstants.userId: LocalData.userId,
//     };
//     UpdateStatusModel? updateStatusModel =
//     await ApiMethods.mentorUpdateAppointmentStatusApi(
//         bodyParams: bodyParam);
//     if (updateStatusModel != null && updateStatusModel.status == '1') {
//       CommonWidgets.showMyToastMessage(updateStatusModel.message ??
//           'Update status  successfully complete.....');
//       print("Update status successfully complete.....");
//       await _dispose();
//       Navigator.pop(context);
//     } else {
//       print('Update status failed.....');
//       CommonWidgets.showMyToastMessage(
//           updateStatusModel?.message ?? 'Update status  failed.....');
//     }
//   }
//
// }

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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

class VideoCallScreen extends StatefulWidget {
  final GetAppointmentListResult appointmentListResult;
  final String token;
  final String channelName;

  const VideoCallScreen({
    super.key,
    required this.appointmentListResult,
    required this.token,
    required this.channelName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _muted = false;
  bool _cameraFront = true;
  late RtcEngine _engine;
  bool _isScreenSharing = false; // Flag to track screen sharing

  int? _startTime;
  int _elapsedTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.systemAlertWindow,
      Permission.storage,
    ].request();

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
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
          _startTime = DateTime.now().toUtc().millisecondsSinceEpoch;
          _startTimer();
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

  void _startTimer() {
    if (_startTime != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime =
              ((DateTime.now().toUtc().millisecondsSinceEpoch - _startTime!) /
                  1000)
                  .floor();
        });
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
    _timer?.cancel();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
    setState(() {
      _cameraFront = !_cameraFront;
    });
  }

  void _onCallEnd(BuildContext context) async {
    await _dispose();
    Navigator.pop(context);
  }

  // Show the remote video if available
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  // Start screen sharing
  void _startScreenSharing() async {
    try {
      await _engine.startScreenCapture(const ScreenCaptureParameters2(
          captureAudio: true, captureVideo: true));

      setState(() {
        _isScreenSharing = true;
      });
    } catch (e) {
      print('Error starting screen share: $e');
    }
  }

  // Stop screen sharing
  void _stopScreenSharing() async {
    try {
      await _engine.stopScreenCapture();
      setState(() {
        _isScreenSharing = false;
      });
    } catch (e) {
      print('Error stopping screen share: $e');
    }
  }

  // Toggle screen sharing
  void _onToggleScreenShare() {
    if (_isScreenSharing) {
      _stopScreenSharing();
    } else {
      _startScreenSharing();
    }
  }

  // Show the shared screen or video
  Widget _sharedScreenOrVideo() {
    if (_isScreenSharing) {
      return _screenShareView(); // Show screen share
    } else {
      return _remoteVideo(); // Show video call
    }
  }

  // View for screen sharing (local user)
  Widget _screenShareView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0), // Local canvas for screen share
      ),
    );
  }

  // Build the top bar with Close session button
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Video Call'),
      ),
      body: Stack(
        children: [
          Center(child: _sharedScreenOrVideo()), // Show video or screen share
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          _buildTopBar(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _formatTime(_elapsedTime),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  IconButton(
                    onPressed: _onToggleMute,
                    icon: Icon(
                      _muted ? Icons.mic_off : Icons.mic,
                      color: _muted ? Colors.red : Colors.white,
                    ),
                    tooltip: _muted ? "Unmute" : "Mute",
                  ),
                  IconButton(
                    onPressed: () => _onCallEnd(context),
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    tooltip: "End Call",
                  ),
                  IconButton(
                    onPressed: _onSwitchCamera,
                    icon: const Icon(Icons.switch_camera, color: Colors.white),
                    tooltip: "Switch Camera",
                  ),
                  IconButton(
                    onPressed: _onToggleScreenShare, // Toggle screen share
                    icon: Icon(
                      _isScreenSharing
                          ? Icons.stop_screen_share
                          : Icons.screen_share,
                      color: _isScreenSharing ? Colors.red : Colors.white,
                    ),
                    tooltip: _isScreenSharing
                        ? "Stop Screen Share"
                        : "Start Screen Share",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
