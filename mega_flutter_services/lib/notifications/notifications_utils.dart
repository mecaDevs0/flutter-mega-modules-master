import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationUtils {
  static Future<void> configure({
    required String appKey,
    required Function(String) onUserId,
  }) async {
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize(appKey);
    await OneSignal.Notifications.requestPermission(true);

    OneSignal.User.pushSubscription.addObserver((changes) {
      final String? userId = changes.current.id;
      print('=============== ONE SIGNAL LOG ===============');
      print('UserId: $userId');
      print('==============================================');

      if (userId != null) {
        onUserId(userId);
      }
    });
  }
}
