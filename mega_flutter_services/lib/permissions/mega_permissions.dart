import 'package:permission_handler/permission_handler.dart';

class MegaPermissions {
  static Future<MegaPermissionStatus> requestPermission({
    required MegaPermissionsType permission,
  }) async {
    final status = await permission.convertedTo.request();
    return MegaPermissionStatusExtension.converted(status);
  }
}

enum MegaPermissionsType {
  camera,
  download,
  location,
  locationAlways,
  locationWhenInUse
}

enum MegaPermissionStatus {
  undetermined,
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

extension MegaPermissionsTypeExtension on MegaPermissionsType {
  Permission get convertedTo {
    switch (this) {
      case MegaPermissionsType.camera:
        return Permission.camera;
      case MegaPermissionsType.download:
        return Permission.storage;
      default:
        return Permission.camera;
    }
  }
}

extension MegaPermissionStatusExtension on MegaPermissionStatus {
  static MegaPermissionStatus converted(
    PermissionStatus permission,
  ) {
    switch (permission) {
      case PermissionStatus.granted:
        return MegaPermissionStatus.granted;
      case PermissionStatus.denied:
        return MegaPermissionStatus.denied;
      case PermissionStatus.restricted:
        return MegaPermissionStatus.restricted;
      case PermissionStatus.permanentlyDenied:
        return MegaPermissionStatus.permanentlyDenied;
      default:
        return MegaPermissionStatus.undetermined;
    }
  }
}
