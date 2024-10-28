import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class HandleCashback{
  static ApiConsumer apiConsumer = serviceLocator<ApiConsumer>();
  static setCount(String key)async{
    if(serviceLocator<UserCubit>().isLoggedIn==false){
      return;
    }
    int? num = await CacheManager.getInt(key);
    if(num==null){
      num=1;
      CacheManager.setInt(key,num);
    }else{
      if(num==9){
        num=0;
        CacheManager.setInt(key,num);
        postCashbackRequest();
      }else{
        num++;
        CacheManager.setInt(key,num);
      }
      print("$key $num");
    }
  }


  static postCashbackRequest() async {
    Dio dio = Dio();
    String token = await CacheManager.getAccessToken() ?? '';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(
        'https://49dev.com/api/v1/cashback/any',
      );
      print('Response data: ${response.data}');
    } catch (error) {
      print('Error: $error');
    }
  }

}