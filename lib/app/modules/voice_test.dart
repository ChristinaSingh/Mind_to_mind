import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceStreamPage extends StatefulWidget {
  const VoiceStreamPage({super.key});

  @override
  State<VoiceStreamPage> createState() => _VoiceStreamPageState();
}

class _VoiceStreamPageState extends State<VoiceStreamPage> {
  WebSocketChannel? channel;
  final recorder = AudioRecorder();
  StreamSubscription<Uint8List>? audioStreamSubscription;
  bool isRecording = false;
  bool isConnected = false;
  String serverMessage = "Waiting...";

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  /// 🔹 Connect WebSocket
  void _connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('wss://python.aitechnotech.in/clgnerd/ws/mobile-transcribe'),
      );

      setState(() => isConnected = true);

      /// 🔹 Receive server messages
      channel!.stream.listen(
            (message) {
          debugPrint("SERVER: $message");
          setState(() {
            serverMessage = message.toString();
          });
        },
        onError: (error) {
          debugPrint("WebSocket Error: $error");
          setState(() {
            isConnected = false;
            serverMessage = "Connection Error: $error";
          });
        },
        onDone: () {
          debugPrint("WebSocket Closed");
          setState(() {
            isConnected = false;
            serverMessage = "Connection Closed";
          });
        },
      );
    } catch (e) {
      debugPrint("Connection Failed: $e");
      setState(() {
        isConnected = false;
        serverMessage = "Failed to connect: $e";
      });
    }
  }

  /// 🎙 Start Recording & Streaming
  Future<void> startRecording() async {
    // Check microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      debugPrint("Microphone permission denied");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required")),
      );
      return;
    }

    // Check if already recording
    if (isRecording) {
      debugPrint("Already recording");
      return;
    }

    // Reconnect WebSocket if needed
    if (!isConnected || channel == null) {
      _connectWebSocket();
      await Future.delayed(const Duration(seconds: 1)); // Wait for connection
    }

    try {
      // Check if recorder has permission
      if (!await recorder.hasPermission()) {
        debugPrint("No recording permission");
        return;
      }

      // Start recording
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ), path: '',
      );

      // Get audio stream
      final stream = await recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      setState(() => isRecording = true);

      // Listen to audio stream and send to WebSocket
      audioStreamSubscription = stream.listen(
            (Uint8List data) {
          if (channel != null && isConnected) {
            channel!.sink.add(data); // 🔥 SEND PCM16 BINARY
            debugPrint("Sent ${data.length} bytes");
          }
        },
        onError: (error) {
          debugPrint("Audio Stream Error: $error");
          stopRecording();
        },
        onDone: () {
          debugPrint("Audio Stream Ended");
          stopRecording();
        },
      );
    } catch (e) {
      debugPrint("Recording Error: $e");
      setState(() => isRecording = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recording failed: $e")),
      );
    }
  }

  /// ⏹ Stop Recording
  Future<void> stopRecording() async {
    if (!isRecording) return;

    try {
      // Cancel audio stream subscription
      await audioStreamSubscription?.cancel();
      audioStreamSubscription = null;

      // Stop recorder
      await recorder.stop();

      // Send stop message
      if (channel != null && isConnected) {
        channel!.sink.add('{"type":"stop"}');
      }

      setState(() => isRecording = false);
      debugPrint("Recording stopped");
    } catch (e) {
      debugPrint("Stop Recording Error: $e");
    }
  }

  @override
  void dispose() {
    audioStreamSubscription?.cancel();
    recorder.dispose();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PCM16 WebSocket Demo"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Connection Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.error,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isConnected ? "Connected" : "Disconnected",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isConnected ? Colors.green[900] : Colors.red[900],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Server Message Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Server Response:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      serverMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Recording Status Indicator
              if (isRecording)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Recording...",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Start/Stop Buttons
              ElevatedButton.icon(
                onPressed: isRecording ? null : startRecording,
                icon: const Icon(Icons.mic),
                label: const Text("Start Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(200, 50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: isRecording ? stopRecording : null,
                icon: const Icon(Icons.stop),
                label: const Text("Stop Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(200, 50),
                ),
              ),
              const SizedBox(height: 20),

              // Reconnect Button
              if (!isConnected)
                TextButton.icon(
                  onPressed: _connectWebSocket,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reconnect"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}