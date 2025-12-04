import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Handler_Permission {

  Future<Position?> getLocation() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return Future.error("Izin ditolak Permanen");
    } else if (status.isGranted){
      bool locationEnabled = await  Geolocator.isLocationServiceEnabled();

      if (!locationEnabled) {
        return Future.error("GPS tidak Aktif");
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  Future<String> getaddress(Position pos) async {
    List<Placemark> placemark = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    Placemark place = placemark.first;
    return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
  }
}