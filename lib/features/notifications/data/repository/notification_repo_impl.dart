// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:fourtyninehub/core/api/api_consumer.dart';
//
// import 'package:fourtyninehub/core/data/models/notification_model.dart';
//
// import 'package:fourtyninehub/core/error/failure.dart';
//
// import '../../../../core/api/end_points.dart';
// import '../../../../core/api/google_api_consumer.dart';
// import 'notification_repo.dart';
// class ApiService {
//   final String _baseUrl = 'https://49dev.com/';
//
//   final Dio dio;
//
//   ApiService(this.dio);
//
//   Future<Map<String,dynamic>> ge({
//     required String url,
//     String? token,
//   }) async {
//     var response = await dio.get(
//       '$_baseUrl$url',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAwZjM0YmViLWRiMTktNGQ0My1iZDlhLWYzNzE2M2I5ZmM0ZiIsImlhdCI6MTcyNDMzOTI4NSwiZXhwIjo1NTcyNDMzOTI4NSwic3ViIjoiNjZjNmY1NjE0YjM5YTkxYTMyY2U1ZTYwIn0.B7P--eYWxcMoshyNkZMwO6Dz1fZcRqTLR0jxQKAxu90' // Use the full token here
//         },
//       ),
//     );
//     // Check if the response is a Map or a List
//     if (response.data is Map<String, dynamic>) {
//       return response.data as Map<String, dynamic>;
//     } else if (response.data is List<dynamic>) {
//       // Handle the case where the response is a List
//       // You might need to adjust this based on your API response structure
//       return {'data': response.data};
//     } else {
//       // Handle unexpected response types
//       throw Exception('Unexpected response type');
//     }
//   }
// }
// class NotificationRepoImpl implements NotificationRepo{
//  final ApiService apiService;
//
//   NotificationRepoImpl(this.apiService);
//   @override
//   Future<Either<Failure, NotificationModel>> fetchNotifications() async{
//    // try{
//      var data =await apiService.ge(url: 'api/v1/notifications');
//      var notification=NotificationModel.fromJson(data);
//      return right(notification);
//     // }catch(e){
//     //   return left(CacheFailure());
//     // }
//   }
//
// }