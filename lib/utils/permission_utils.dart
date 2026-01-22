// lib/utils/permission_utils.dart → VERSI FINAL YANG MUNCUL DIALOG SAMA PERSIS KAMERA

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// GALERI → MUNCUL DIALOG IZIN SAMA PERSIS KAMERA
  static Future<XFile?> pickFromGallery() async {
    // Paksa minta izin dulu biar muncul dialog sistem
    final status = await Permission.photos.request();
    if (!status.isGranted) return null;

    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1920,
      maxHeight: 1920,
    );
  }

  /// Kamera (tetap sama)
  static Future<XFile?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;

    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    );
  }
}