import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../models/notification.dart';
import 'notifications_repository.dart';

class NotificationsBloc extends BlocBase {
  final NotificationsRepository _repository;

  NotificationsBloc(this._repository);

  var _page = 1;
  final _notifications = BehaviorSubject<List<NotificationModel>>();
  Sink<List<NotificationModel>> get _notificationsIn => _notifications.sink;
  Stream<List<NotificationModel>> get notifications => _notifications.stream;

  Future<void> loadNotifications() async {
    _page = 1;
    BlocUtils.load(action: (_) async {
      final response = await _repository.loadNotifications(page: _page);
      _notificationsIn.add(response);
      if (response.isNotEmpty) {
        _page++;
      }
    });
  }

  loadMoreNotifications() async {
    // BlocUtils.load(
    //   showLoadingList: true,
    //   action: (_) async {
    //     final response = await _repository.loadNotifications(page: _page);
    //     final pushes = _notifications.value;
    //     pushes.addAll(response);
    //     _notificationsIn.add(pushes);
    //     if (response.isNotEmpty) {
    //       _page++;
    //     }
    //   },
    // );
  }

  setRead(NotificationModel notification) async {
    BlocUtils.load(
      showLoading: false,
      action: (_) async {
        await _repository.setRead(notification);
        _notifications.value
            .firstWhere((n) => n.id == notification.id)
            .dateRead = DateTime.now().millisecondsSinceEpoch;
        _notificationsIn.add(_notifications.value);
      },
    );
  }

  Future<void> removeNotification({required String id}) async {
    BlocUtils.load(
      action: (_) async {
        final _ = await _repository.removeNotifications(id: id);
        _notifications.value.removeWhere((element) => element.id == id);
        _notificationsIn.add(_notifications.value);
      },
    );
  }

  @override
  void dispose() {
    _notifications.close();
    super.dispose();
  }
}
