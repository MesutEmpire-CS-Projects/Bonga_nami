import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      return _requestForPermission();
    }
    return status.isGranted;
  }

  Future<bool> _requestForPermission() async {
    final PermissionStatus perm = await Permission.microphone.request();
    return perm.isGranted;
  }
}
