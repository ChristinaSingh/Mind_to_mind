// media_picker_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mindtomind/common/colors.dart';

// ✅ NO permission_handler import at all

enum MediaType { text, image, video, document }

class MediaPickerSheet extends StatelessWidget {
  final Function(File, MediaType) onFilePicked;

  const MediaPickerSheet({super.key, required this.onFilePicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Share Media',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ── Camera ───────────────────────────────────────────────────
              // ✅ Just call pickImage directly — iOS shows native dialog itself
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                      maxWidth: 1024,
                      maxHeight: 1024,
                    );
                    if (file != null) {
                      onFilePicked(File(file.path), MediaType.image);
                    }
                  } catch (e) {
                    debugPrint('Camera error: $e');
                  }
                },
              ),

              // ── Gallery ───────────────────────────────────────────────────
              // ✅ Just call pickImage directly — iOS shows native photo picker
              _buildOption(
                context,
                icon: Icons.photo_library,
                label: 'Gallery',
                color: Colors.purple,
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                      maxWidth: 1024,
                      maxHeight: 1024,
                    );
                    if (file != null) {
                      onFilePicked(File(file.path), MediaType.image);
                    }
                  } catch (e) {
                    debugPrint('Gallery error: $e');
                  }
                },
              ),

              // ── Video ─────────────────────────────────────────────────────
              // ✅ iOS shows its own native camera+mic permission dialog
              _buildOption(
                context,
                icon: Icons.videocam,
                label: 'Video',
                color: Colors.red,
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? file = await ImagePicker().pickVideo(
                      source: ImageSource.camera,
                      maxDuration: const Duration(minutes: 5),
                    );
                    if (file != null) {
                      onFilePicked(File(file.path), MediaType.video);
                    }
                  } catch (e) {
                    debugPrint('Video error: $e');
                  }
                },
              ),

              // ── Document ──────────────────────────────────────────────────
              // ✅ No permission needed on iOS
              _buildOption(
                context,
                icon: Icons.attach_file,
                label: 'Document',
                color: Colors.orange,
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [
                        'pdf', 'doc', 'docx',
                        'xls', 'xlsx',
                        'ppt', 'pptx', 'txt'
                      ],
                    );
                    if (result != null && result.files.single.path != null) {
                      onFilePicked(
                        File(result.files.single.path!),
                        MediaType.document,
                      );
                    }
                  } catch (e) {
                    debugPrint('Document error: $e');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}