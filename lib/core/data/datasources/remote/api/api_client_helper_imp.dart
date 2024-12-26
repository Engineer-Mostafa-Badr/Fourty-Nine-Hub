// import 'package:dio/dio.dart';

// import 'api_client_helper.dart';

// class ApiClientHelperImp extends ApiClientHelper {
//   Map<String, dynamic> baseHeaders = {};
//   Dio dio = Dio(BaseOptions(
//     validateStatus: (status) {
//       return status != null && status <= 500;
//     },
//   ));
//   @override

//   Future delete(
//       {required String url,
//       Map<String, dynamic>? data,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? headers,
//       bool token = false}) {
//     return dio.delete(url,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(
//           headers: authorization(
//               headers: headers,
//               token: token
//                   ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjcxMThiNzJmLTQ2MDMtNGFmYy1hYzE5LTY5Yjk0MDAxZmEyZCIsImlhdCI6MTcyMjk2ODE2NSwiZXhwIjo1NTcyMjk2ODE2NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.nCOyVo3IZzelMeQWxe_eFl8gA9jGU08_30RLuh0-6Cw'
//                   : null),
//         ));
//   }

//   @override
//   Future get(
//       {required String url,
//       Map<String, dynamic>? data,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? headers,
//       bool token = false}) {
//     return dio.get(url,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(
//           headers: authorization(
//               headers: headers,
//               token: token
//                   ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjcxMThiNzJmLTQ2MDMtNGFmYy1hYzE5LTY5Yjk0MDAxZmEyZCIsImlhdCI6MTcyMjk2ODE2NSwiZXhwIjo1NTcyMjk2ODE2NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.nCOyVo3IZzelMeQWxe_eFl8gA9jGU08_30RLuh0-6Cw'
//                   : null),
//         ));
//   }

//   @override
//   Future post(
//       {required String url,
//       Map<String, dynamic>? data,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? headers,
//       bool token = false}) {
//     return dio.post(url,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(
//           headers: authorization(
//               headers: headers,
//               token: token
//                   ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjcxMThiNzJmLTQ2MDMtNGFmYy1hYzE5LTY5Yjk0MDAxZmEyZCIsImlhdCI6MTcyMjk2ODE2NSwiZXhwIjo1NTcyMjk2ODE2NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.nCOyVo3IZzelMeQWxe_eFl8gA9jGU08_30RLuh0-6Cw'
//                   : null),
//         ));
//   }

//   @override
//   Future put(
//       {required String url,
//       Map<String, dynamic>? data,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? headers,
//       bool token = false}) {
//     return dio.put(url,
//         data: data,
//         queryParameters: queryParameters,
//         options: Options(
//           headers: authorization(
//               headers: headers,
//               token: token
//                   ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjcxMThiNzJmLTQ2MDMtNGFmYy1hYzE5LTY5Yjk0MDAxZmEyZCIsImlhdCI6MTcyMjk2ODE2NSwiZXhwIjo1NTcyMjk2ODE2NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.nCOyVo3IZzelMeQWxe_eFl8gA9jGU08_30RLuh0-6Cw'
//                   : null),
//         ));
//   }

//   // @override
//   Map<String, dynamic> authorization(
//       {Map<String, dynamic>? headers, String? token}) {
//     if (token != null) {
//       baseHeaders.addAll({"Authorization": "Bearer $token"});
//       if (headers != null) {
//         baseHeaders.addAll(headers);
//       }
//     } else {
//       if (headers != null) {
//         baseHeaders.addAll(headers);
//       }
//     }
//     return baseHeaders;
//   }
// }
