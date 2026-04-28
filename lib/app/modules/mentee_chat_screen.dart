import 'dart:async';
import 'dart:io';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mindtomind/common/colors.dart';
import 'package:mindtomind/common/local_data.dart';

import '../../common/document_viewer.dart';
import '../../common/image_viewer.dart';
import '../../common/media_picker_sheet.dart';
import '../../common/media_service.dart' hide MediaType;
import '../../common/video_player_screen.dart';
import '../data/apis/api_models/get_appointmentlist_model.dart';
import '../data/apis/api_models/get_history_data.dart';

enum _ChatPhase { waitingToStart, inProgress, readOnly }

class MenteeChatScreen extends StatefulWidget {
  final GetAppointmentListResult? appointmentListResult;
  final NotificationResult? notificationResult;
  final String token;
  final String receiverId;
  final String status;

  const MenteeChatScreen({
    super.key,
    this.appointmentListResult,
    this.notificationResult,
    required this.token,
    required this.receiverId,
    required this.status,
  });

  @override
  State<MenteeChatScreen> createState() => _MenteeChatScreenState();
}

class _MenteeChatScreenState extends State<MenteeChatScreen> {
  late AgoraRtmClient _rtmClient;
  final String _appId = "78d0ddb8da264ed69395598a3cb3c73d";
  final String _userId = LocalData.userId;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String chatId;

  bool _isUploading = false;
  double _uploadProgress = 0;
  bool _isEndingChat = false; // loading state for end chat API

  _ChatPhase _phase = _ChatPhase.readOnly;
  Duration _timerDisplay = Duration.zero;
  DateTime? _appointmentStart;
  DateTime? _sessionEnd;
  Timer? _ticker;

  bool get _canSend => _phase == _ChatPhase.inProgress && !_isUploading;

  // ── lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initRtmClient();
    chatId = _buildChatId(_userId, widget.receiverId);
    _loadChatHistory();
    _listenToChatStream();
    _initPhase();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ── Phase logic ───────────────────────────────────────────────────────────

  void _initPhase() {
    if (widget.status.toLowerCase() != 'ongoing') {
      setState(() => _phase = _ChatPhase.readOnly);
      return;
    }

    final startStr = widget.appointmentListResult?.startTime ??
        widget.notificationResult?.startTime;
    final endStr = widget.appointmentListResult?.endTime ??
        widget.notificationResult?.endTime;

    print("Initializing chat phase → startTime: $startStr | endTime: $endStr");

    if (startStr == null || endStr == null) {
      setState(() => _phase = _ChatPhase.inProgress);
      return;
    }

    _appointmentStart = _parseFullDateTime(startStr);
    _sessionEnd      = _parseFullDateTime(endStr);

    if (_appointmentStart == null || _sessionEnd == null) {
      setState(() => _phase = _ChatPhase.inProgress);
      return;
    }

    _evaluatePhase();
    _startTicker();
  }

  /// Parses "2026-03-26 20:00:00" or any ISO-8601-style string.
  DateTime? _parseFullDateTime(String s) {
    try {
      return DateTime.parse(s.trim());
    } catch (_) {
      return null;
    }
  }

  void _evaluatePhase() {
    if (_appointmentStart == null || _sessionEnd == null) return;
    final now = DateTime.now();
    if (now.isBefore(_appointmentStart!)) {
      _phase = _ChatPhase.waitingToStart;
      _timerDisplay = _appointmentStart!.difference(now);
    } else if (now.isBefore(_sessionEnd!)) {
      _phase = _ChatPhase.inProgress;
      _timerDisplay = _sessionEnd!.difference(now);
    } else {
      _phase = _ChatPhase.readOnly;
      _timerDisplay = Duration.zero;
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final prev = _phase;
      _evaluatePhase();
      setState(() {});
      // Auto-expire when time is up
      if (prev == _ChatPhase.inProgress && _phase == _ChatPhase.readOnly) {
        _ticker?.cancel();
        _callEndChatApi(showDialog: true); // auto end + show dialog
      }
    });
  }

  // ── End Chat API ──────────────────────────────────────────────────────────

  /// Calls the end_chat_connection endpoint.
  /// [showDialog] = true when called automatically (time up).
  /// [showDialog] = false when we just want the API call silently
  ///   (dialog already shown by the manual flow).
  Future<void> _callEndChatApi({bool showDialog = false}) async {
    final appointmentId =
        widget.appointmentListResult?.id ?? widget.notificationResult?.id;
    if (appointmentId == null) return;

    try {
      final response = await http.post(
        Uri.parse(
            'https://s81.technorizen.com/mind2mind/webservice/end_chat_connection'),
        body: {'id': appointmentId.toString()},
      );
      final data = jsonDecode(response.body);
      debugPrint('End chat response: $data');
    } catch (e) {
      debugPrint('End chat API error: $e');
    }

    // Move to read-only regardless of API result
    _ticker?.cancel();
    if (mounted) {
      setState(() {
        _phase = _ChatPhase.readOnly;
        _timerDisplay = Duration.zero;
      });
    }

    if (showDialog && mounted) {
      _showSessionEndDialog();
    }
  }

  // ── Manual end chat ───────────────────────────────────────────────────────

  /// Shows confirmation dialog → on confirm calls API → moves to readOnly
  void _showEndChatConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.stop_circle_outlined, color: Colors.red, size: 28),
          SizedBox(width: 10),
          Expanded(
              child: Text('End Chat', style: TextStyle(fontSize: 18))),
        ]),
        content: const Text(
          'Are you sure you want to end this chat session?\n\n'
              'You can still view the chat history after ending.',
          style: TextStyle(fontFamily: "Poppins", height: 1.5),
        ),
        actions: [
          // Cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey[600], fontFamily: "Poppins")),
          ),
          // End Chat
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // close dialog
              setState(() => _isEndingChat = true);
              await _callEndChatApi(showDialog: false);
              if (mounted) setState(() => _isEndingChat = false);
              // Show a brief snack to confirm
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Chat session ended. You can still view the history.',
                      style: TextStyle(fontFamily: "Poppins"),
                    ),
                    backgroundColor: Colors.green.shade700,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('End Chat',
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Session-end auto dialog ───────────────────────────────────────────────

  void _showSessionEndDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.access_time, color: Colors.orange, size: 28),
          SizedBox(width: 10),
          Expanded(
              child: Text('Session Ended', style: TextStyle(fontSize: 18))),
        ]),
        content: const Text(
            'Your chat session has ended. Thank you for using our service!',
            style: TextStyle(fontFamily: "Poppins")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _buildChatId(String a, String b) => ([a, b]..sort()).join("_");

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  DateTime? _parseDateTime(String dateStr, String timeStr) {
    try {
      DateTime? date;
      for (final fmt in [
        'yyyy-MM-dd', 'dd-MM-yyyy', 'MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy/MM/dd'
      ]) {
        try {
          date = DateFormat(fmt).parse(dateStr);
          break;
        } catch (_) {}
      }
      if (date == null) return null;
      final clean = timeStr.trim().toUpperCase();
      int h = 0, m = 0;
      if (clean.contains('AM') || clean.contains('PM')) {
        final parts = clean.replaceAll(RegExp(r'[APM\s]'), '').split(':');
        h = int.parse(parts[0]);
        m = parts.length > 1 ? int.parse(parts[1]) : 0;
        if (clean.contains('PM') && h != 12) h += 12;
        if (clean.contains('AM') && h == 12) h = 0;
      } else {
        final parts = clean.split(':');
        h = int.parse(parts[0]);
        m = parts.length > 1 ? int.parse(parts[1]) : 0;
      }
      return DateTime(date.year, date.month, date.day, h, m);
    } catch (_) {
      return null;
    }
  }

  String _formatDisplayDate(String? s) {
    if (s == null) return 'N/A';
    try {
      DateTime? d;
      for (final fmt in [
        'yyyy-MM-dd', 'dd-MM-yyyy', 'MM/dd/yyyy', 'dd/MM/yyyy'
      ]) {
        try {
          d = DateFormat(fmt).parse(s);
          break;
        } catch (_) {}
      }
      if (d != null) return DateFormat('MMM dd, yyyy').format(d);
    } catch (_) {}
    return s;
  }

  // ── Firestore ─────────────────────────────────────────────────────────────

  Future<void> _loadChatHistory() async {
    final snapshot = await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp")
        .get();
    if (mounted) {
      setState(() =>
      _messages..clear()..addAll(snapshot.docs.map(_docToMessage)));
    }
  }

  void _listenToChatStream() {
    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots()
        .listen((snap) {
      if (!mounted) return;
      setState(
              () => _messages..clear()..addAll(snap.docs.map(_docToMessage)));
      _scrollToBottom();
    });
  }

  Map<String, dynamic> _docToMessage(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data["timestamp"];
    return {
      "text": data["text"] ?? "",
      "senderId": data["senderId"],
      "type": data["senderId"] == _userId ? "sent" : "received",
      "time": ts is Timestamp ? ts.toDate() : DateTime.now(),
      "mediaType": data["mediaType"] ?? "text",
      "mediaUrl": data["mediaUrl"],
      "fileName": data["fileName"],
      "fileSize": data["fileSize"],
    };
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }

  Future<void> _saveMessageToFirestore({
    required String senderId,
    required String receiverId,
    String? text,
    String? mediaType,
    String? mediaUrl,
    String? fileName,
    int? fileSize,
  }) async {
    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text ?? "",
      "mediaType": mediaType ?? "text",
      "mediaUrl": mediaUrl,
      "fileName": fileName,
      "fileSize": fileSize,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // ── Agora RTM ─────────────────────────────────────────────────────────────

  Future<void> _initRtmClient() async {
    try {
      _rtmClient = await AgoraRtmClient.createInstance(_appId);
      await _rtmClient.login(widget.token, _userId);
      _rtmClient.onMessageReceived = (_, __) {};
      _rtmClient.onConnectionStateChanged =
          (s, r) => debugPrint("RTM $s/$r");
    } catch (e) {
      debugPrint("RTM: $e");
    }
  }

  Future<void> _sendPeerMessage() async {
    print("_sendPeerMessage${_canSend}");
    if (!_canSend) return;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    try {
      // await _rtmClient.sendMessageToPeer(
      //     widget.receiverId, AgoraRtmMessage.fromText(text), false);
      await _saveMessageToFirestore(
          senderId: _userId,
          receiverId: widget.receiverId,
          text: text,
          mediaType: "text");
      _messageController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      debugPrint("Send: $e");
    }
  }

  Future<void> _sendMediaMessage(File file, MediaType mediaType) async {
    if (!_canSend) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      final r = await MediaService.uploadFile(
          file: file,
          chatId: chatId,
          senderId: _userId,
          onProgress: (p) => setState(() => _uploadProgress = p));
      if (r != null) {
        // await _rtmClient.sendMessageToPeer(
        //     widget.receiverId,
        //     AgoraRtmMessage.fromText(
        //         '[${mediaType.name.toUpperCase()}] ${r['fileName']}'),
        //     false);
        await _saveMessageToFirestore(
            senderId: _userId,
            receiverId: widget.receiverId,
            text: "",
            mediaType: r['mediaType'],
            mediaUrl: r['url'],
            fileName: r['fileName'],
            fileSize: r['fileSize']);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to upload media'),
            backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0;
      });
    }
  }

  void _showMediaPicker() {
    if (!_canSend) return;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => MediaPickerSheet(
            onFilePicked: (f, t) => _sendMediaMessage(f, t)));
  }

  void _openMedia(Map<String, dynamic> msg) {
    final type = msg['mediaType'] ?? 'text';
    final url = msg['mediaUrl'];
    if (url == null) return;
    switch (type) {
      case 'image':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ImageViewerScreen(
                    imageUrl: url, fileName: msg['fileName'])));
        break;
      case 'video':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(
                    videoUrl: url, fileName: msg['fileName'])));
        break;
      case 'document':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DocumentViewerScreen(
                    documentUrl: url,
                    fileName: msg['fileName'] ?? 'document',
                    fileSize: msg['fileSize'])));
        break;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Chat',
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600)),
        // ── End Chat button — only shown when session is inProgress ──────
        actions: [
          if (_phase == _ChatPhase.inProgress)
            _isEndingChat
                ? const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.red),
              ),
            )
                : TextButton.icon(
              onPressed: _showEndChatConfirmDialog,
              icon: const Icon(Icons.stop_circle_outlined,
                  color: Colors.red, size: 18),
              label: const Text(
                'End Chat',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoHeader(),
          if (_phase == _ChatPhase.waitingToStart) _buildWaitingBanner(),
          Expanded(
            child: _messages.isEmpty && !_isUploading
                ? _buildEmptyState()
                : ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length + (_isUploading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_isUploading && i == 0)
                    return _buildUploadingIndicator();
                  final idx = _isUploading ? i - 1 : i;
                  return _buildMessageBubble(
                      _messages[_messages.length - 1 - idx]);
                }),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Waiting banner ────────────────────────────────────────────────────────

  Widget _buildWaitingBanner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border:
        Border(bottom: BorderSide(color: Colors.orange.shade200))),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.hourglass_top_rounded,
          size: 18, color: Colors.orange.shade700),
      const SizedBox(width: 8),
      Text('Session starts in  ${_fmt(_timerDisplay)}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700,
              fontFamily: "Poppins")),
    ]),
  );

  // ── Info header ───────────────────────────────────────────────────────────

  Widget _buildInfoHeader() {
    final mentor = widget.appointmentListResult?.mentorDetails;
    final appointment = widget.appointmentListResult;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 2)),
            child: ClipOval(
              child: mentor?.image != null
                  ? CachedNetworkImage(
                  imageUrl: mentor!.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _avatarPlaceholder(),
                  errorWidget: (_, __, ___) => _avatarPlaceholder())
                  : _avatarPlaceholder(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentor?.name ?? 'Mentor',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins")),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: _phase == _ChatPhase.inProgress
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(_statusSubtitle,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontFamily: "Poppins")),
                    ]),
                  ])),
          _buildTimerBadge(),
        ]),
        if (appointment != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1), blurRadius: 3)
                ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(Icons.calendar_today, 'Date',
                      _formatDisplayDate(appointment.appointmentDate)),
                  Container(
                      width: 1, height: 30, color: Colors.grey.shade300),
                  _buildInfoItem(Icons.access_time, 'Time', appointment.timeRange),
                  Container(
                      width: 1, height: 30, color: Colors.grey.shade300),
                  _buildInfoItem(
                      Icons.hourglass_bottom, 'Duration', '1 Hour'),
                ]),
          ),
        ],
      ]),
    );
  }

  // ── Timer badge ───────────────────────────────────────────────────────────

  Widget _buildTimerBadge() {
    switch (_phase) {
      case _ChatPhase.waitingToStart:
        final t = _appointmentStart != null
            ? DateFormat('hh:mm a').format(_appointmentStart!)
            : '--:--';
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
              const SizedBox(width: 4),
              Text(t,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                      fontFamily: "Poppins")),
            ]));
      case _ChatPhase.inProgress:
        final isLow = _timerDisplay.inMinutes < 10;
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: isLow ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isLow ? Colors.red : Colors.green)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.access_time,
                  size: 16, color: isLow ? Colors.red : Colors.green),
              const SizedBox(width: 4),
              Text(_fmt(_timerDisplay),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLow ? Colors.red : Colors.green,
                      fontFamily: "Poppins")),
            ]));
      case _ChatPhase.readOnly:
        final lbl = widget.status.toLowerCase() == 'cancelled'
            ? 'Cancelled'
            : widget.status.toLowerCase() == 'pending'
            ? 'Pending'
            : 'Completed';
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: Text(lbl,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")));
    }
  }

  String get _statusSubtitle {
    switch (_phase) {
      case _ChatPhase.waitingToStart:
        return 'Waiting for session to start';
      case _ChatPhase.inProgress:
        return 'Online';
      case _ChatPhase.readOnly:
        switch (widget.status.toLowerCase()) {
          case 'complete':
            return 'Session Completed';
          case 'cancelled':
            return 'Session Cancelled';
          case 'pending':
            return 'Session Pending';
          default:
            return 'Session Completed';
        }
    }
  }

  Widget _buildInfoItem(IconData icon, String label, String value) =>
      Expanded(
          child: Column(children: [
            Icon(icon, size: 20, color: primaryColor),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontFamily: "Poppins")),
            Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ]));

  Widget _avatarPlaceholder() => Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: const Icon(Icons.person, size: 40));

  Widget _buildEmptyState() {
    final msg = _phase == _ChatPhase.waitingToStart
        ? 'Chat opens when the session starts'
        : _phase == _ChatPhase.inProgress
        ? 'Start the conversation!'
        : 'No messages were exchanged';
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No messages yet',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontFamily: "Poppins")),
              const SizedBox(height: 8),
              Text(msg,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      fontFamily: "Poppins")),
            ]));
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    if (_phase == _ChatPhase.waitingToStart) {
      return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border(
                  top: BorderSide(color: Colors.orange.shade200))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_clock, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text('Messaging opens when session starts',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                        fontFamily: "Poppins")),
              ]));
    }

    if (_phase == _ChatPhase.inProgress) {
      return Container(
          padding: Platform.isIOS
              ? const EdgeInsets.only(
              bottom: 25, left: 12, right: 12, top: 8)
              : const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -2))
          ]),
          child: Row(children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100], shape: BoxShape.circle),
                child: IconButton(
                    icon: Icon(Icons.attach_file, color: primaryColor),
                    onPressed: _isUploading ? null : _showMediaPicker)),
            const SizedBox(width: 8),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontFamily: "Poppins"),
                      decoration: const InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.grey),
                          border: InputBorder.none)),
                )),
            const SizedBox(width: 8),
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.7)
                    ]),
                    shape: BoxShape.circle),
                child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isUploading ? null : _sendPeerMessage)),
          ]));
    }

    // Read-only bar
    Color barColor;
    IconData barIcon;
    String barText;
    switch (widget.status.toLowerCase()) {
      case 'complete':
        barColor = Colors.green.shade700;
        barIcon = Icons.check_circle;
        barText = 'Session completed — view only';
        break;
      case 'cancelled':
        barColor = Colors.red.shade700;
        barIcon = Icons.cancel;
        barText = 'Session cancelled — view only';
        break;
      case 'pending':
        barColor = Colors.blue.shade700;
        barIcon = Icons.schedule;
        barText = 'Session not started yet — view only';
        break;
      default:
        barColor = Colors.green.shade700;
        barIcon = Icons.check_circle;
        barText = 'Session ended — view only';
    }
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border:
            Border(top: BorderSide(color: Colors.grey.shade300))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(barIcon, color: barColor, size: 18),
              const SizedBox(width: 8),
              Text(barText,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                      fontFamily: "Poppins")),
            ]));
  }

  // ── Message bubble ────────────────────────────────────────────────────────

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isSent = message["type"] == "sent";
    final time = DateFormat('hh:mm a').format(message["time"]);
    final mediaType = message["mediaType"] ?? "text";
    return Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Column(
                crossAxisAlignment: isSent
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: mediaType != "text"
                          ? () => _openMedia(message)
                          : null,
                      child: Container(
                          padding: mediaType == "text"
                              ? const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16)
                              : const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              gradient: isSent
                                  ? LinearGradient(colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.7)
                              ])
                                  : null,
                              color: isSent ? null : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft:
                                  Radius.circular(isSent ? 20 : 5),
                                  bottomRight:
                                  Radius.circular(isSent ? 5 : 20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2))
                              ]),
                          child: _buildMessageContent(
                              message, isSent, mediaType))),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 4, left: 4, right: 4),
                      child:
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(time,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontFamily: "Poppins")),
                        if (isSent) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.done_all,
                              size: 14, color: Colors.blue[700])
                        ],
                      ])),
                ])));
  }

  Widget _buildMessageContent(
      Map<String, dynamic> msg, bool isSent, String mediaType) {
    switch (mediaType) {
      case 'image':
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(children: [
              CachedNetworkImage(
                  imageUrl: msg['mediaUrl'] ?? '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                          child: CircularProgressIndicator())),
                  errorWidget: (_, __, ___) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error))),
              Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Icon(Icons.fullscreen,
                          color: Colors.white, size: 20))),
            ]));
      case 'video':
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
                width: 200,
                height: 150,
                color: Colors.black,
                child: Stack(alignment: Alignment.center, children: [
                  const Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 50),
                  Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Row(children: [
                            Icon(Icons.videocam,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Video',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ]))),
                ])));
      case 'document':
        return Container(
            padding: const EdgeInsets.all(12),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isSent
                          ? Colors.white.withOpacity(0.2)
                          : primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                      MediaService.getFileIcon(msg['fileName'] ?? ''),
                      color: isSent ? Colors.white : primaryColor,
                      size: 30)),
              const SizedBox(width: 12),
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['fileName'] ?? 'Document',
                            style: TextStyle(
                                color:
                                isSent ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                            overflow: TextOverflow.ellipsis),
                        if (msg['fileSize'] != null)
                          Text(
                              MediaService.getFileSizeString(
                                  msg['fileSize']),
                              style: TextStyle(
                                  color: isSent
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 12,
                                  fontFamily: "Poppins")),
                      ])),
              const SizedBox(width: 8),
              Icon(Icons.download,
                  color: isSent ? Colors.white : primaryColor, size: 24),
            ]));
      default:
        return Text(msg["text"] ?? "",
            style: TextStyle(
                fontSize: 15,
                color: isSent ? Colors.white : Colors.black87,
                fontFamily: "Poppins"));
    }
  }

  Widget _buildUploadingIndicator() => Container(
      padding: const EdgeInsets.all(12),
      margin:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      value: _uploadProgress,
                      strokeWidth: 2,
                      color: primaryColor)),
              const SizedBox(width: 12),
              Text('Uploading ${(_uploadProgress * 100).toInt()}%',
                  style: TextStyle(
                      color: primaryColor, fontFamily: "Poppins")),
            ])),
      ]));
}