// import 'package:permission_handler/permission_handler.dart';
//
// class Permissions {
//   Future<bool> listenForPermissions() async {
//     final status = await Permission.microphone.status;
//     switch (status) {
//       case PermissionStatus.denied:
//         return _requestForPermission();
//         break;
//       case PermissionStatus.granted:
//         return false;
//         break;
//       case PermissionStatus.limited:
//         return false;
//         break;
//       case PermissionStatus.permanentlyDenied:
//         return false;
//         break;
//       case PermissionStatus.restricted:
//         return false;
//         break;
//       case PermissionStatus.provisional:
//         return false;
//         break;
//     }
//   }
//
//   Future<bool> _requestForPermission() async {
//     final PermissionStatus perm = await Permission.microphone.request();
//     return perm.isGranted;
//   }
// }

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
