import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/models/notification_model.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/shared_pref.dart';
import 'notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo{
 final ApiService apiService;

  NotificationRepoImpl(this.apiService);
  @override
  Future<Either<Failure, NotificationModel>> fetchNotifications() async{
    String? accessToken = await TokenManager.getAccessToken();
    String? refreshToken = await TokenManager.getRefreshToken();
   // try{
     var data =await apiService.get(url: 'api/v1/notifications',token: accessToken);
     var notification=NotificationModel.fromJson(data);
     return right(notification);
    // }catch(e){
    //   return left(CacheFailure());
    // }
  }

}