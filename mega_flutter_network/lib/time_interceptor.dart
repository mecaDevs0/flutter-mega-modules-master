import 'package:dio/dio.dart';

class TimeInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    options.headers['X-Request-Time'] = time;
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final requestTime = response.requestOptions.headers['X-Request-Time'];
    final diff = time - requestTime;
    final diffInSec = diff / 1000;
    print('DIFF TIME: TOOK $diff MS ($diffInSec SECONDS)');

    super.onResponse(response, handler);
  }
}
