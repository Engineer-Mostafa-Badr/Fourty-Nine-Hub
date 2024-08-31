import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/models/notification_model.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/shared_pref.dart';
import '../models/delete_notification_model.dart';
import 'notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final ApiService apiService;

  NotificationRepoImpl(this.apiService);
  @override
  Future<Either<Failure, NotificationModel>> fetchNotifications(
      String type) async {
    String? accessToken = await TokenManager.getAccessToken();
    String? refreshToken = await TokenManager.getRefreshToken();
    // try{
    var data = await apiService.get(
        url: 'api/v1/notifications?type=$type', token: accessToken);
    var notification = NotificationModel.fromJson(data);
    return right(notification);
    // }catch(e){
    //   return left(CacheFailure());
    // }
  }

  @override
  Future<Either<Failure, DeleteNotificationModel>> deleteItemNotifications(
      String id) async {
    String? accessToken = await TokenManager.getAccessToken();
    String? refreshToken = await TokenManager.getRefreshToken();
    var data = await apiService.delete(
        url: 'api/v1/notifications/$id', token: accessToken);
    var notification = DeleteNotificationModel.fromJson(data);
    return right(notification);
  }
}

// Failure handleApiError(dynamic error) {
//   if (error is DioError) {
//     // Handle Dio-specific errors
//     if (error.response != null) {
//       // Server errors (e.g., 500, 404, etc.)
//       return ServerFailure(
//         message: error.response?.statusMessage ?? 'Server error occurred',
//         statusCode: error.response?.statusCode,
//         errors: (error.response?.data['errors'] as List<dynamic>?)
//             ?.map((e) => e.toString())
//             .toList(),
//       );
//     } else if (error.type == DioErrorType.connectTimeout ||
//         error.type == DioErrorType.receiveTimeout) {
//       // Handle timeout errors
//       return ServerFailure(message: 'Connection timeout');
//     } else if (error.type == DioErrorType.response &&
//         error.response?.statusCode == 401) {
//       // Unauthorized error
//       return UnauthorizedFailure();
//     } else {
//       // Other Dio errors
//       return UnknownFailure();
//     }
//   } else if (error is CacheException) {
//     // Handle cache-related errors
//     return CacheFailure();
//   } else {
//     // Fallback to an unknown failure for any other errors
//     return UnknownFailure();
//   }
// }
