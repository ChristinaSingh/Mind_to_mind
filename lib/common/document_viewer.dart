import 'package:flutter/material.dart';

import '../../common/colors.dart';
import 'media_service.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String documentUrl;
  final String fileName;
  final int? fileSize;

  const DocumentViewerScreen({
    super.key,
    required this.documentUrl,
    required this.fileName,
    this.fileSize,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _downloadedPath;

  Future<void> _downloadAndOpen() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    final path = await MediaService.downloadFile(
      url: widget.documentUrl,
      fileName: widget.fileName,
      onProgress: (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      },
    );

    setState(() {
      _isDownloading = false;
      _downloadedPath = path;
    });

    if (path != null) {
      await MediaService.openFile(path);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download document'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.fileName,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  MediaService.getFileIcon(widget.fileName),
                  size: 80,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.fileName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.fileSize != null) ...[
                const SizedBox(height: 8),
                Text(
                  MediaService.getFileSizeString(widget.fileSize!),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: "Poppins",
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (_isDownloading) ...[
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: Colors.grey[300],
                        color: primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_downloadProgress * 100).toInt()}%',
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _downloadAndOpen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download),
                  label: Text(
                    _downloadedPath != null ? 'Open Document' : 'Download & Open',
                    style: const TextStyle(fontFamily: "Poppins"),
                  ),
                ),
                if (_downloadedPath != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Saved to: $_downloadedPath',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: "Poppins",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}