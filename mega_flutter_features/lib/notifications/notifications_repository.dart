import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/mega_dio.dart';

import '../models/notification.dart';

class NotificationsRepository {
  final String? loadPath;
  final String? setReadPath;
  final String? removePath;

  NotificationsRepository({
    this.loadPath,
    this.setReadPath,
    this.removePath,
  });

  Future<List<NotificationModel>> loadNotifications({required int page}) async {
    if (this.loadPath == null || this.loadPath!.isEmpty) {
      throw UnimplementedError();
    }

    final response = await Modular.get<MegaDio>().get(
      '$loadPath/$page',
      queryParameters: {'setRead': true},
    );

    return (response.data as List)
        .map((n) => NotificationModel.fromJson(n))
        .toList();
  }

  Future<NotificationModel> setRead(NotificationModel notification) async {
    if (this.setReadPath == null || this.setReadPath!.isEmpty) {
      throw UnimplementedError();
    }

    await Modular.get<MegaDio>().get(setReadPath!);

    notification.dateRead = DateTime.now().millisecondsSinceEpoch;
    return notification;
  }

  Future<void> removeNotifications({required String id}) async {
    if (this.removePath == null || this.removePath!.isEmpty) {
      throw UnimplementedError();
    }

    await Modular.get<MegaDio>().post('$removePath$id');
  }
}
