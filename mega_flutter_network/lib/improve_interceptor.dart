import 'package:dio/dio.dart';

class ImproveInterceptor extends InterceptorsWrapper {
  ImproveInterceptor();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.data != null && options.data is Map) {
      options.data.removeWhere((_, value) => value == null);

      (options.data as Map).values.map((value) {
        if (value is String) {
          return value.trim();
        }
        return value;
      });
    }
    return super.onRequest(options, handler);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
