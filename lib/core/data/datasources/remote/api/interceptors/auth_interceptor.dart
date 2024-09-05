import 'package:dio/dio.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppPages.router.configuration.navigatorKey.currentContext!
          .pushAndRemoveUntil(Routes.REGISTER, ((route) => false));
    }
    super.onError(err, handler);
  }
}
