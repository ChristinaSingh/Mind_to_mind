import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum PermissionType {
  camera,
  microphone,
  photos,
  storage,
}

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check and request camera permission
  static Future<bool> handleCameraPermission(BuildContext context) async {
    return await _handlePermission(
      context: context,
      permission: Permission.camera,
      permissionName: 'Camera',
      description: 'Camera access is required to take photos and record videos.',
      icon: Icons.camera_alt,
    );
  }

  /// Check and request microphone permission
  static Future<bool> handleMicrophonePermission(BuildContext context) async {
    return await _handlePermission(
      context: context,
      permission: Permission.microphone,
      permissionName: 'Microphone',
      description: 'Microphone access is required to record audio and video.',
      icon: Icons.mic,
    );
  }

  /// Check and request photos/gallery permission
  static Future<bool> handlePhotosPermission(BuildContext context) async {
    Permission permission;

    if (Platform.isIOS) {
      // For iOS 14+, use photos permission
      permission = Permission.photos;
    } else {
      // For Android, check SDK version
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ uses specific media permissions
        permission = Permission.photos;
      } else {
        // Older Android uses storage
        permission = Permission.storage;
      }
    }

    return await _handlePermission(
      context: context,
      permission: permission,
      permissionName: 'Photo Library',
      description: 'Photo library access is required to select and share images.',
      icon: Icons.photo_library,
    );
  }

  /// Check and request storage permission (for documents)
  static Future<bool> handleStoragePermission(BuildContext context) async {
    if (Platform.isIOS) {
      // iOS doesn't require explicit storage permission for documents
      return true;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      // Android 13+ - check for specific permissions
      final photosStatus = await Permission.photos.status;
      final videosStatus = await Permission.videos.status;

      if (photosStatus.isGranted && videosStatus.isGranted) {
        return true;
      }

      // Request both
      final results = await [
        Permission.photos,
        Permission.videos,
      ].request();

      return results[Permission.photos]!.isGranted &&
          results[Permission.videos]!.isGranted;
    } else if (androidInfo.version.sdkInt >= 30) {
      // Android 11-12
      return await _handlePermission(
        context: context,
        permission: Permission.manageExternalStorage,
        permissionName: 'Storage',
        description: 'Storage access is required to share files and documents.',
        icon: Icons.folder,
      );
    } else {
      // Android 10 and below
      return await _handlePermission(
        context: context,
        permission: Permission.storage,
        permissionName: 'Storage',
        description: 'Storage access is required to share files and documents.',
        icon: Icons.folder,
      );
    }
  }

  /// Handle multiple permissions for media picker
  static Future<Map<PermissionType, bool>> handleMediaPickerPermissions(
      BuildContext context, {
        bool needsCamera = true,
        bool needsPhotos = true,
        bool needsStorage = true,
      }) async {
    Map<PermissionType, bool> results = {};

    if (needsCamera) {
      results[PermissionType.camera] = await handleCameraPermission(context);
    }

    if (needsPhotos) {
      results[PermissionType.photos] = await handlePhotosPermission(context);
    }

    if (needsStorage) {
      results[PermissionType.storage] = await handleStoragePermission(context);
    }

    return results;
  }

  /// Core permission handling logic
  static Future<bool> _handlePermission({
    required BuildContext context,
    required Permission permission,
    required String permissionName,
    required String description,
    required IconData icon,
  }) async {
    // Check current status
    PermissionStatus status = await permission.status;

    // If already granted, return true
    if (status.isGranted) {
      return true;
    }

    // If limited (iOS photos), it's still usable
    if (status.isLimited) {
      return true;
    }

    // If denied but not permanently, show explanation and request
    if (status.isDenied) {
      // Show explanation dialog first
      final shouldRequest = await _showPermissionExplanationDialog(
        context: context,
        permissionName: permissionName,
        description: description,
        icon: icon,
      );

      if (shouldRequest) {
        status = await permission.request();

        if (status.isGranted || status.isLimited) {
          return true;
        }

        // If still denied after request
        if (status.isPermanentlyDenied) {
          await _showSettingsDialog(context, permissionName, description, icon);
          return false;
        }
      }
      return false;
    }

    // If permanently denied, show settings dialog
    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context, permissionName, description, icon);
      return false;
    }

    // If restricted (iOS parental controls)
    if (status.isRestricted) {
      _showRestrictedDialog(context, permissionName);
      return false;
    }

    // Default: try to request
    status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  /// Show explanation dialog before requesting permission
  static Future<bool> _showPermissionExplanationDialog({
    required BuildContext context,
    required String permissionName,
    required String description,
    required IconData icon,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$permissionName Permission',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(fontSize: 14, fontFamily: "Poppins"),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'You can change this later in Settings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Not Now',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show settings dialog when permanently denied
  static Future<void> _showSettingsDialog(
      BuildContext context,
      String permissionName,
      String description,
      IconData icon,
      ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.orange, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$permissionName Required',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              style: const TextStyle(fontSize: 14, fontFamily: "Poppins"),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please enable $permissionName access in Settings to use this feature.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Open Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show restricted dialog (iOS parental controls)
  static void _showRestrictedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.block, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Access Restricted',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          '$permissionName access is restricted on this device. This may be due to parental controls or device policy.',
          style: const TextStyle(fontSize: 14, fontFamily: "Poppins"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Quick check for all required chat permissions
  static Future<bool> hasAllChatPermissions() async {
    final camera = await Permission.camera.status;
    final photos = await Permission.photos.status;

    return camera.isGranted && (photos.isGranted || photos.isLimited);
  }
}