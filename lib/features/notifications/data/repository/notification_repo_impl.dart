import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/models/notification_model.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../core/utils/shared_pref.dart';
import 'notification_repo.dart';

class ApiService {
  final String _baseUrl = 'https://49dev.com/';

  final Dio dio;

  ApiService(this.dio);

  Future<Map<String,dynamic>> ge({
    required String url,
    String? token,
  }) async {
    var response = await dio.get(
      '$_baseUrl$url',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        },
      ),
    );
    // Check if the response is a Map or a List
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else if (response.data is List<dynamic>) {
      // Handle the case where the response is a List
      // You might need to adjust this based on your API response structure
      return {'data': response.data};
    } else {
      // Handle unexpected response types
      throw Exception('Unexpected response type');
    }
  }
}
class NotificationRepoImpl implements NotificationRepo{
 final ApiService apiService;

  NotificationRepoImpl(this.apiService);
  @override
  Future<Either<Failure, NotificationModel>> fetchNotifications() async{
    String? accessToken = await TokenManager.getAccessToken();
    String? refreshToken = await TokenManager.getRefreshToken();
   // try{
     var data =await apiService.ge(url: 'api/v1/notifications',token: accessToken);
     var notification=NotificationModel.fromJson(data);
     return right(notification);
    // }catch(e){
    //   return left(CacheFailure());
    // }
  }

}