import 'package:dio/dio.dart';

class LanguageInterceptor extends Interceptor {
  //final LanguageCubit languageCubit;

  LanguageInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //options.headers['lang'] = languageCubit.state.languageCode;
    handler.next(options);
    //super.onRequest(options, handler);
  }
}
