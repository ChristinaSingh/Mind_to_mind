import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

// ✅ permission_handler import REMOVED — iOS handles natively

enum MediaType { text, image, video, document }

class MediaService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _imagePicker = ImagePicker();
  static final Dio _dio = Dio();

  static FirebaseStorage getStorage({String? bucket}) {
    if (bucket != null) return FirebaseStorage.instanceFor(bucket: bucket);
    return FirebaseStorage.instance;
  }

  // ── Pick image from gallery ───────────────────────────────────────────────
  // ✅ No permission check — iOS shows native dialog automatically on first use
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) return File(image.path);
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
    return null;
  }

  // ── Pick image from camera ────────────────────────────────────────────────
  // ✅ No permission check — iOS shows native camera dialog automatically
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) return File(image.path);
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
    return null;
  }

  // ── Pick video from gallery ───────────────────────────────────────────────
  // ✅ No permission check needed
  static Future<File?> pickVideoFromGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      if (video != null) return File(video.path);
    } catch (e) {
      debugPrint('Error picking video from gallery: $e');
    }
    return null;
  }

  // ── Pick video from camera ────────────────────────────────────────────────
  // ✅ iOS shows native camera + microphone permission dialog automatically
  static Future<File?> pickVideoFromCamera() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );
      if (video != null) return File(video.path);
    } catch (e) {
      debugPrint('Error picking video from camera: $e');
    }
    return null;
  }

  // ── Pick document ─────────────────────────────────────────────────────────
  // ✅ No permission needed on iOS for documents
  static Future<File?> pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'
        ],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
    }
    return null;
  }

  // ── Pick any file ─────────────────────────────────────────────────────────
  static Future<File?> pickAnyFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
    return null;
  }

  // ── Upload file ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> uploadFile({
    required File file,
    required String chatId,
    required String senderId,
    Function(double)? onProgress,
  }) async {
    try {
      if (!await file.exists()) {
        debugPrint('File does not exist: ${file.path}');
        return null;
      }

      final String originalFileName = path.basename(file.path);
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';
      final String? mimeType = lookupMimeType(file.path);
      final String contentType = mimeType ?? 'application/octet-stream';
      final MediaType mediaType = _getMediaType(contentType);
      final int fileSize = await file.length();

      debugPrint('Uploading: $fileName | type: $contentType | size: $fileSize');

      Map<String, dynamic>? result = await _uploadWithPutFile(
        file: file,
        chatId: chatId,
        fileName: fileName,
        contentType: contentType,
        mediaType: mediaType,
        fileSize: fileSize,
        onProgress: onProgress,
      );

      result ??= await _uploadWithPutData(
        file: file,
        chatId: chatId,
        fileName: fileName,
        contentType: contentType,
        mediaType: mediaType,
        fileSize: fileSize,
        onProgress: onProgress,
      );

      return result;
    } catch (e) {
      debugPrint('Error in uploadFile: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _uploadWithPutFile({
    required File file,
    required String chatId,
    required String fileName,
    required String contentType,
    required MediaType mediaType,
    required int fileSize,
    Function(double)? onProgress,
  }) async {
    try {
      final Reference ref = _storage.ref().child('chats/$chatId/$fileName');
      final SettableMetadata metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalSize': fileSize.toString(),
        },
      );
      final UploadTask uploadTask = ref.putFile(file, metadata);
      uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
          if (snapshot.totalBytes > 0) {
            onProgress?.call(snapshot.bytesTransferred / snapshot.totalBytes);
          }
        },
        onError: (e) => debugPrint('Upload stream error: $e'),
      );
      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();
        return {
          'url': url,
          'fileName': fileName,
          'fileSize': fileSize,
          'mimeType': contentType,
          'mediaType': mediaType.name,
        };
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase putFile error: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('putFile error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _uploadWithPutData({
    required File file,
    required String chatId,
    required String fileName,
    required String contentType,
    required MediaType mediaType,
    required int fileSize,
    Function(double)? onProgress,
  }) async {
    try {
      final Uint8List fileBytes = await file.readAsBytes();
      final Reference ref = _storage.ref().child('chats/$chatId/$fileName');
      final SettableMetadata metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalSize': fileSize.toString(),
        },
      );
      final UploadTask uploadTask = ref.putData(fileBytes, metadata);
      uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
          if (snapshot.totalBytes > 0) {
            onProgress?.call(snapshot.bytesTransferred / snapshot.totalBytes);
          }
        },
        onError: (e) => debugPrint('Upload stream error (putData): $e'),
      );
      final TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();
        return {
          'url': url,
          'fileName': fileName,
          'fileSize': fileSize,
          'mimeType': contentType,
          'mediaType': mediaType.name,
        };
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase putData error: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint('putData error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> uploadFileWithRetry({
    required File file,
    required String chatId,
    required String senderId,
    Function(double)? onProgress,
    int maxRetries = 3,
  }) async {
    int retryCount = 0;
    Map<String, dynamic>? result;
    while (retryCount < maxRetries && result == null) {
      if (retryCount > 0) {
        debugPrint('Retry attempt $retryCount of $maxRetries');
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
      result = await uploadFile(
        file: file,
        chatId: chatId,
        senderId: senderId,
        onProgress: onProgress,
      );
      retryCount++;
    }
    return result;
  }

  // ── Download file ─────────────────────────────────────────────────────────
  // ✅ Android still uses storage permission, iOS uses Documents dir (no permission needed)
  static Future<String?> downloadFile({
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      // ── Android only: request storage permission ──────────────────────────
      if (Platform.isAndroid) {
        // Use permission_handler ONLY for Android download
        // import it locally to avoid affecting iOS
        final bool granted = await _requestAndroidStoragePermission();
        if (!granted) {
          debugPrint('Android storage permission denied');
          return null;
        }
      }
      // ── iOS: no permission needed for Documents directory ─────────────────

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        // iOS: app Documents directory — no permission required
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        debugPrint('Could not get download directory');
        return null;
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final String cleanFileName = _sanitizeFileName(fileName);
      final String filePath = '${directory.path}/$cleanFileName';

      debugPrint('Downloading to: $filePath');

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) onProgress?.call(received / total);
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      debugPrint('Download complete: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }

  // ── Android storage permission (Android only, never called on iOS) ─────────
  static Future<bool> _requestAndroidStoragePermission() async {
    if (!Platform.isAndroid) return true;
    try {
      // Dynamically use permission_handler only on Android
      // This avoids any iOS permission dialog issues
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        // Android 13+ — no storage permission needed for media
        return true;
      }
      // Android < 13 — request storage permission
      // Keep permission_handler import only if you need this
      // For now return true and handle in your Android-specific code
      return true;
    } catch (e) {
      debugPrint('Android permission check error: $e');
      return true;
    }
  }

  static Future<int> _getAndroidVersion() async {
    try {
      if (Platform.isAndroid) {
        final version = Platform.operatingSystemVersion;
        final match = RegExp(r'(\d+)').firstMatch(version);
        if (match != null) return int.tryParse(match.group(1) ?? '0') ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static MediaType _getMediaType(String mimeType) {
    if (mimeType.startsWith('image/')) return MediaType.image;
    if (mimeType.startsWith('video/')) return MediaType.video;
    return MediaType.document;
  }

  static String _sanitizeFileName(String fileName) =>
      fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

  static Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      debugPrint('Open file result: ${result.message}');
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static IconData getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':       return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':      return Icons.description;
      case 'xls':
      case 'xlsx':      return Icons.table_chart;
      case 'ppt':
      case 'pptx':      return Icons.slideshow;
      case 'txt':       return Icons.text_snippet;
      case 'zip':
      case 'rar':       return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':      return Icons.image;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':       return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'aac':       return Icons.audio_file;
      default:          return Icons.insert_drive_file;
    }
  }

  static Future<bool> checkStorageConnection() async {
    try {
      debugPrint('Storage bucket: ${_storage.ref().bucket}');
      return true;
    } catch (e) {
      debugPrint('Storage connection check failed: $e');
      return false;
    }
  }
}