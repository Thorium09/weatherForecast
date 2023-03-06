import 'package:permission_handler/permission_handler.dart';

class PermissionAccess {
  Future<bool> requestPermissions() async {
    // Request multiple permissions using the `request()` method
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      // Permission.camera,
      // Permission.storage,
    ].request();

    PermissionStatus locationStatus = statuses[Permission.location]!;

    if (locationStatus != PermissionStatus.granted) {
      throw Error();
    }
    // else {
    //   return await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best,
    //   );
    // }

    return true;
  }
}
