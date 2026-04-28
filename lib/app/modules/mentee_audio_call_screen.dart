//
// import 'dart:ui';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../common/colors.dart';
// import '../../common/common_widgets.dart';
// import '../data/apis/api_models/get_appointmentlist_model.dart';
//
// class MenteeAudioCallScreen extends StatefulWidget {
//   final GetAppointmentListResult appointmentListResult;
//
//   const MenteeAudioCallScreen({super.key, required this.appointmentListResult});
//
//   @override
//   State<MenteeAudioCallScreen> createState() => _MenteeAudioCallScreenState();
// }
//
// class _MenteeAudioCallScreenState extends State<MenteeAudioCallScreen> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   bool _muted = false;
//
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // Permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     // Create Agora engine
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
//           _engine.setEnableSpeakerphone(false);
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
//       ),
//     );
//
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: widget.appointmentListResult.token!,
//       channelId: widget.appointmentListResult.channelName!,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }
//
//   // Dispose resources
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   // Toggle Mute
//   void _onToggleMute() {
//     setState(() {
//       _muted = !_muted;
//     });
//     _engine.muteLocalAudioStream(_muted);
//   }
//
//   // Leave Call
//   void _onCallEnd(BuildContext context) async {
//     await _dispose();
//     Navigator.pop(context);
//   }
//
//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonWidgets.appBar(
//           wantBackButton: true, title: widget.appointmentListResult.mentorDetails!.name ?? ""),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(
//                   sigmaX: 5.0,
//                   sigmaY: 5.0,
//                 ),
//                 child: CachedNetworkImage(
//                   imageUrl: widget.appointmentListResult.mentorDetails!.image ??
//                       "https://picsum.photos/200/300",
//                   fit: BoxFit.fill,
//                   placeholder: (context, url) => const Center(
//                       child: CircularProgressIndicator(
//                     color: primaryColor,
//                   )),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//             _buildBottomBar(context)
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Bottom Bar
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
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Remote Video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(
//               channelId: widget.appointmentListResult.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }


import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/colors.dart';
import '../../common/common_widgets.dart';
import '../data/apis/api_models/get_appointmentlist_model.dart';

class MenteeAudioCallScreen extends StatefulWidget {
  final GetAppointmentListResult appointmentListResult;

  const MenteeAudioCallScreen({super.key, required this.appointmentListResult});

  @override
  State<MenteeAudioCallScreen> createState() => _MenteeAudioCallScreenState();
}

class _MenteeAudioCallScreenState extends State<MenteeAudioCallScreen> {
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

          // Set the default audio route to speakerphone
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
      token: widget.appointmentListResult.token!,
      channelId: widget.appointmentListResult.channelName!,
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

  // Switch between speakerphone and earpiece
  void _toggleAudioRoute() async {
    if (_muted) return; // Don't change route while muted
    final currentSpeakerphoneStatus = await _engine.isSpeakerphoneEnabled();
    await _engine.setEnableSpeakerphone(!currentSpeakerphoneStatus);
    setState(() {
    });
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
      appBar: CommonWidgets.appBar(
          wantBackButton: true, title: widget.appointmentListResult.mentorDetails!.name ?? ""),
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
                  imageUrl: widget.appointmentListResult.mentorDetails!.image ??
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
            _buildBottomBar(context)
          ],
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
            // Toggle Audio Route Button
            // IconButton(
            //   onPressed: _toggleAudioRoute,
            //   icon: const Icon(
            //     Icons.volume_up,
            //     color: Colors.white,
            //   ),
            //   tooltip: "Toggle Speaker/Earpiece",
            // ),
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
}
