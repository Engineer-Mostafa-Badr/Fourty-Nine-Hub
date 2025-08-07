import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/service/cache_service.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../models/driver_register_request_model.dart';
import '../models/request_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ShippingDataSource {
  ApiConsumer api;
  final CacheService cacheService;
  ShippingDataSource({required this.api, required this.cacheService});
  Future<Either<Failure, Map<String, dynamic>>> getBannerData() async {
    // String? token = await cacheService.getUserToken() ?? "";
    String? token = await CacheManager.getAccessToken() ?? "";
    log(token, name: "lllllllllllllllllllllllllddddddddddddddddd");
    String? userId = extractUserId(token);
    // extractUserId(token ?? "");
    if (userId == null) {
      return api.get(EndPoints.bannerData);
    } else {
      return api.get("${EndPoints.bannerData}?userId=$userId");
    }
  }

// 66b76065ab3b6f5a3d2273ed
//66c349d7a684ab473f1c1ed7
  Future<Either<Failure, Map<String, dynamic>>> getS3(
      {required String endpoint, Map<String, dynamic>? data}) async {
    CacheService cacheService = CacheServiceImpl();
    // var token = await cacheService.getUserToken();
    var token = await CacheManager.getAccessToken();
    log(token.toString(), name: "TOKENTOKEN");
    log(data.toString(), name: "DATADATADATA");
    log("${EndPoints.developmentBaseUrl}$endpoint", name: "endpointendpoint");
    var resposne = await Dio().put("${EndPoints.developmentBaseUrl}$endpoint",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    if (resposne.statusCode == 200 || resposne.statusCode == 201) {
      return Right(resposne.data);
    } else {
      log(resposne.data.toString(), name: "S3 Error failure");
      return const Left(ServerFailure(message: "message"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> register(
      {required DriverRegisterRequestModel model}) {
    return api.post(EndPoints.registerDriver, data: model.register());
  }

  Future<Either<Failure, Map<String, dynamic>>> favorite({required String id}) {
    return api.post(
      "${EndPoints.favoriteSubCategory}/$id",
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> favoriteMain(
      {required String id}) {
    return api.post("${EndPoints.favoriteCategory}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> createTrip(
      {required RequestModel model}) {
    log(model.create().toString(), name: "alksjdflkasjdflskjf");
    return api.post(
      EndPoints.createLoadingTrip,
      data: model.create(),
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllTripBySubCategory() {
    return api.get(EndPoints.getAllTripBySubCategory);
  }

// "${EndPoints.getAllTripBySubCategory}/${cacheService.getSubCategryDriver()}"
  //trip
  Future<Either<Failure, Map<String, dynamic>>> sendOfferPremium(
      {required String id, required double price}) {
    return api.post(EndPoints.createLoadingTrip,
        data: {"loadingTripId": id, "price": price});
  }

  Future<Either<Failure, Map<String, dynamic>>> sendOffer(
      {required String id, required double price}) {
    return api
        .post(EndPoints.sendOffer, data: {"loadingTripId": id, "price": price});
  }

  Future<Either<Failure, Map<String, dynamic>>> report({
    required String loadingTripId,
  }) {
    return api.post(EndPoints.reportUrl, data: {
      "reason": "res",
      "userId": "66a50ff048ab2520b1590a43", // id of spamy spam user
      "content": "con",
      "category": "loading",
      /** 'nudity', 'frequent', 'fake', 'abuse', 'hated', 'illegal', 'politics',*/
      "categoryId":
          "62c8baad8e28a58a3edf5805", // id of the service reels /facebook/twitter
      //"chatId":"",
      //"postId":"",
      //"reelId":"",
      // "tinderUserId":"66ae36f02a49669dbe641037",
      // "driverId":"",
      "loadingTripId": loadingTripId
    });
  }

  // Future<Either<Failure, Map<String, dynamic>>> acceptLoadingTripOffer(
  //     {required String id}) {
  //   return api
  //       .post(EndPoints.acceptLoadingTripOffer, data: {"loadingRequestId": id});
  // }

  Future<Either<Failure, Map<String, dynamic>>> signedUrl(
      {required Map<String, dynamic> json}) {
    return api.post(EndPoints.mediasignedUrl, data: json);
  }

  Future<Either<Failure, Map<String, dynamic>>> confirm({required String id}) {
    return api.put("${EndPoints.mediaconfirm}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> callMessage(
      {required String ownerId, required String subcategoryId}) async {
    // String? token = await cacheService.getUserToken() ?? "";
    String? token = await CacheManager.getAccessToken() ?? "";
    log(token, name: "lllllllllllllllllllllllllddddddddddddddddd");
    String? userId = extractUserId(token);
    return api.post(EndPoints.click, data: {
      "clientId": userId,
      "ownerId": ownerId,
      "subcategoryId": subcategoryId
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getMyTrip() {
    return api.get(
      EndPoints.allUserTrips,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> loadingTripRequests() async {
    return api.get(EndPoints.loadingTripRequests);
  }

  Future<Either<Failure, Map<String, dynamic>>> getShippingRequests() async {
    return api.get(EndPoints.allUserTrips);
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptTrip(
      {required String loadingRequestId}) async {
    return api.post(EndPoints.acceptLoadingTripOffer,
        data: {"loadingRequestId": loadingRequestId});
  }

  Future<Either<Failure, Map<String, dynamic>>> declineTrip(
      {required String loadingRequestId}) async {
    return api.post(EndPoints.cancelOffer,
        data: {"loadingRequestId": loadingRequestId});
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelTrip(
      {required String tripId}) async {
    return api.delete("${EndPoints.deleteLoadingTrip}/$tripId");
  }

  Future<Either<Failure, Map<String, dynamic>>> getDrive() async {
    return api.get(EndPoints.getDriverData,
        queryParameters: {"subCategory": "62c8baad8e28a58a3edf5805"});
  }

  Future<Either<Failure, Map<String, dynamic>>> updateDriver(
      DriverRegisterRequestModel model) async {
    log(model.register().toString(), name: "3333333333333333333333333");
    return api.put(EndPoints.updateDriver, data: model.register());
  }

  Future<Either<Failure, Map<String, dynamic>>> completeTrip(
      {required String loadingTrip}) async {
    return api.put("${EndPoints.completeTrip}/$loadingTrip");
  }

  Future<Either<Failure, Map<String, dynamic>>> driverStatistics() async {
    return api.get(EndPoints.driverStatistics);
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteDriver() async {
    return api.delete(EndPoints.deleteDriver);
  }

  String? extractUserId(String token) {
    try {
      log(token, name: "Token");
      // فك تشفير الـ token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      log(decodedToken.toString(), name: "decodedToken");
      // استخراج الـ UserId من الـ payload
      // String userId = decodedToken[
      //     'userId']; // تأكد من أن الـ key هو 'userId' أو الاسم الصحيح في الـ token

      // print("UserId هو: $userId");
      return decodedToken['sub'];
    } catch (e) {
      return null;
    }
  }
}
