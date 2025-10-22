import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';

class HandleCashback {
  static ApiConsumer apiConsumer = serviceLocator<ApiConsumer>();
  static setCount(String key, BuildContext context) async {
    if (serviceLocator<UserCubit>().isLoggedIn == false) {
      return;
    }
    int? num = CacheManager.getInt(key);
    if (num == null) {
      num = 1;
      CacheManager.setInt(key, num);
    } else {
      print("num:: $num");
      if (num == 9) {
        num = 0;
        CacheManager.setInt(key, num);
        context.read<MainCategoriesCubit>().anyCashBack();
        print("anyCashBack called");
      } else {
        num++;
        CacheManager.setInt(key, num);
      }
      print("xx1 $key $num");
    }
  }

  static postCashbackRequest() async {
    //
    // final Either<Failure, Map<String, dynamic>> result = await apiConsumer.post(
    //   'https://1d2f0756d123.ngrok-free.app/api/v1/cashback/any',
    // );

    Dio dio = Dio();
    String token = await CacheManager.getAccessToken() ?? '';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    try {
      final response = await dio.post(
        'https://1d2f0756d123.ngrok-free.app/api/v1/cashback/any',
      );
      print('Response data: ${response.data}');
    } catch (error) {
      print('Error: $error');
    }
    dio.interceptors.addAll([
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        )
    ]);
  }
}
