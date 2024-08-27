import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/driver_register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';

class ShippingDataSource {
  ApiConsumer api;
  final CacheService cacheService;
  ShippingDataSource({required this.api, required this.cacheService});
  Future<Either<Failure, Map<String, dynamic>>> getBannerData() {
    log(cacheService.getDriverId().toString(), name: "DriverId");
    return api.get("${EndPoints.bannerData}?userId=66b4659d1c9c4b1cb35bfee4");
  }

  Future<Either<Failure, Map<String, dynamic>>> getS3(
      {required String endpoint, Map<String, dynamic>? data}) {
    return api.put(endpoint, data: data);
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

  Future<Either<Failure, Map<String, dynamic>>> acceptLoadingTripOffer(
      {required String id}) {
    return api
        .post(EndPoints.acceptLoadingTripOffer, data: {"loadingRequestId": id});
  }

  Future<Either<Failure, Map<String, dynamic>>> signedUrl(
      {required Map<String, dynamic> json}) {
    return api.post(EndPoints.mediasignedUrl, data: json);
  }

  Future<Either<Failure, Map<String, dynamic>>> confirm({required String id}) {
    return api.put("${EndPoints.mediaconfirm}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> callMessage(
      {required String ownerId, required String subcategoryId}) {
    return api.post(EndPoints.click, data: {
      "clientId": "66b4659d1c9c4b1cb35bfee4",
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
}
