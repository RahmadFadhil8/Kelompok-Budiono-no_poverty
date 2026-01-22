import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Handler_Permission {
  Future<Position?> getLocation() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      throw "Izin lokasi ditolak Permanen";
    }

    if (status.isGranted) {
      bool locationEnabled = await Geolocator.isLocationServiceEnabled();

      if (!locationEnabled) {
        throw "GPS tidak Aktif";
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  Future<String> getaddress(Position pos) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    Placemark place = placemark.first;
    return "${place.administrativeArea} ${place.country}";
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestGalleryPermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }
}
