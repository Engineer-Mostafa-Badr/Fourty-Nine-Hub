import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_offer_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_trip_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_trip_ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rating_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class RiderDataSource {
  final ApiConsumer api;
  final CacheService cacheService;
  RiderDataSource({required this.api, required this.cacheService});

  Future<Either<Failure, Map<String, dynamic>>> getCateogryData() async {
    // String? token = await cacheService.getUserToken() ?? "";
    String? token = await CacheManager.getAccessToken() ?? "";
    String? userId = extractUserId(token);
    // extractUserId(token ?? "");
    print("USERID============ $userId \n");
    if (userId == null) {
      return api.get(EndPoints.bannerDataRider);
    } else {
      return api.get("${EndPoints.bannerDataRider}?userId=$userId");
    }
    // return api
    //     .get("${EndPoints.bannerDataRider}?userId=66c349d7a684ab473f1c1ed7");
  }

  Future<Either<Failure, Map<String, dynamic>>> registerDriver(
      {required RiderRegisterModel model}) {
    log(jsonEncode(model.registerOne()).toString(), name: "lskdjfslkjdflksjdflksdjfklj");
    return api.post(EndPoints.specialRegister, data: model.registerOne());
  }

  Future<Either<Failure, Map<String, dynamic>>> riderRegister(
      {required RiderRegisterModel model}) {
    log(model.registerTow().toString(), name: "ldjfksldjflskdjf");
    return api.post(EndPoints.riderRegister, data: model.registerTow());
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripInfo(
      {required GetTripInfoRequestModel model}) {
    log(model.toJson().toString(), name: "lsdjflskdjflksdjf");
    return api.post("${EndPoints.expectedPrice}/${model.subCateogryId}",
        data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> pictureOptional() {
    return api.get(EndPoints.pictureOptional);
  }

  Future<Either<Failure, Map<String, dynamic>>> requestTrip(
      {required TripRequestModel model}) {
    return api.post("${EndPoints.newTripRide}/62c8ba9f8e28a58a3edf57eb", data: {
      "price": model.price,
      "fromTitle": model.fromTitle,
      "toTitle": model.toTitle,
      "distance": model.distance,
      "duration": model.duration,
      "startLocation": model.startLocation,
      "targetLocation": model.targetLocation,
      "calculate_b": model.calculateB,
      "paymentMethod": model.paymentMethod,
      "passengers": model.passengers,
      "comfort": model.comfort,
      "autoAccept": model.autoAccept,
      "isPremium": model.isPremium,
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptOfferRide(
      {required String tripId, required String subCategory}) {
    return api
        .put("${EndPoints.acceptOfferRide}/$tripId?subCategory=$subCategory");
  }

  Future<Either<Failure, Map<String, dynamic>>> declineOfferRide(
      {required String tripId}) {
    return api.delete("${EndPoints.declineOfferRide}/$tripId");
  }

  Future<Either<Failure, Map<String, dynamic>>> getExpairedTrip() {
    return api.get(EndPoints.expiredTripRider);
  }

  Future<Either<Failure, Map<String, dynamic>>> checkDriverType() {
    return api.get(EndPoints.checkDriverType);
  }

  Future<Either<Failure, Map<String, dynamic>>> createRequest(
      {required CreateTripRideRequestModel model}) {
    return api.post(EndPoints.createRideTripRequest, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> createRequestPremium(
      {required CreateTripRideRequestModel model}) {
    return api.post(EndPoints.createRideTripRequestPremium,
        data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> getAddressFromLatAndLong(
      {required String address}) {
    return api
        .get(EndPoints.getAddressFromLatAndLong, data: {"address": address});
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptTripByDriver(
      {required String id}) {
    return api.put(EndPoints.acceptTripRider(id));
  }

  Future<Either<Failure, Map<String, dynamic>>> createOfferByDriver(
      {required String id, required double price}) async {
    Position location = await Geolocator.getCurrentPosition();
    return api.post(EndPoints.createOffer(id), data: {
      "priceOffer": price,
      "location": [location.latitude, location.longitude]
    });
  }

  String? extractUserId(String token) {
    try {
      // فك تشفير الـ token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // استخراج الـ UserId من الـ payload
      // String userId = decodedToken[
      //     'userId']; // تأكد من أن الـ key هو 'userId' أو الاسم الصحيح في الـ token

      // print("UserId هو: $userId");
      return decodedToken['sub'];
    } catch (e) {
      return null;
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> riderInStartLocation({
    required String id,
  }) async {
    Position location = await Geolocator.getCurrentPosition();
    return await api.put(
      EndPoints.riderInStartLocation(id),
      data: {
        "location": [
          location.latitude,
          location.longitude,
        ],
      },
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> startTripRider(
      {required String id, required int otp}) {
    return api.put(EndPoints.startTripRider(id), data: {"OTP": otp.toString()});
  }

  Future<Either<Failure, Map<String, dynamic>>> reasons() {
    return api.get(EndPoints.reasons);
  }

  Future<Either<Failure, Map<String, dynamic>>> partialPayment(
      {required String id,
      required double amount,
      required String paymentMethod}) {
    return api.put(EndPoints.partialPayment(id),
        data: {"amount": amount, "paymentMethod": paymentMethod});
  }

  Future<Either<Failure, Map<String, dynamic>>> completedTripRider(
      {required String id}) async {
    Position location = await Geolocator.getCurrentPosition();
    return api.put(EndPoints.completedTripRider(id), data: {
      "location": "",
      "startLocation": [location.latitude, location.longitude]
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelTripRider(
      {required String reasonId, required String note, required String id}) {
    return api.put(EndPoints.cancelTripRider(id),
        data: {"reasonId": reasonId, "note": note});
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelTripClient(
      {required String id, String? reasonId, String? note}) async {
    Position location = await Geolocator.getCurrentPosition();
    if (reasonId != null && note != null) {
      return api.put(EndPoints.cancelTripClient(id), data: {
        "reasonId": reasonId,
        "note": note,
        "riderLocation": [location.latitude, location.longitude]
      });
    } else {
      return api.put(EndPoints.cancelTripClient(id), data: {});
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> checkPayment(
      {required String amount}) {
    return api.post(EndPoints.checkWalletEnough,
        data: {"amount": double.parse(amount)});
  }

  //No Socket
  Future<Either<Failure, Map<String, dynamic>>> createTripNoSocket(
      {required CreateTripNoSocketModel model}) {
    return api.post(EndPoints.createTripNoSocket, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> createPremiumTripNoSocket(
      {required CreateTripNoSocketModel model}) {
    return api.post(EndPoints.createPremiumTripNoSocket, data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> createOfferNoSocket(
      {required CreateOfferNoSocketModel model, required String tripId}) {
    return api.post("${EndPoints.createOfferNoSocket}/$tripId",
        data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> offerAcceptNoSocket(
      {required String id}) {
    return api.put("${EndPoints.offerAcceptNoSocket}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> offerRejectNoSocket(
      {required String id}) {
    return api.put("${EndPoints.offerRejectNoSocket}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllTripNoSocket(
      {required String id}) {
    return api.get("${EndPoints.getAllTripNoSocket}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripOffersNoSocket(
      {required String id}) {
    return api.get("${EndPoints.getTripOffersNoSocket}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> getUserLoginTripNoSocket() {
    return api.get(EndPoints.getUserLoginTripNoSocket);
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteTripNoSocket(
      {required String id}) {
    return api.delete("${EndPoints.deleteTripNoSocket}/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> completeTripNoSocket(
      {required String id}) {
    return api.put("/ride/trip/offer/complete/$id");
  }

  Future<Either<Failure, Map<String, dynamic>>> rating(
      {required RattingDriverModel model}) {
    return api.post("/driver/rating", data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> mediaUrl(
      {required String type,
      required int size,
      required String subcategoryId}) {
    return api.post(EndPoints.mediaUrl, data: {
      "type": "audio/$type",
      "size": size,
      "subcategoryId": subcategoryId
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> recordVoiceRide(
      {required String tripId, required String mediaId}) {
    return api.put("${EndPoints.recordVoiceRide}/$tripId",
        data: {"mediaId": mediaId});
  }

  Future<Either<Failure, Map<String, dynamic>>> confirmUpload(
      {required String mediaId}) {
    return api.put(EndPoints.confirmUpload(mediaId));
  }

  Future<Either<Failure, Map<String, dynamic>>> getDriverInfo() {
    return api.get("/ride/riders/driverStatistics");
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteDriver() {
    return api.delete("/ride/riders");
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarBrand() {
    return api.post(EndPoints.getCarBrand, data: {"brand": ""});
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarModelByBrand(
      {required String brand}) {
    return api.get(EndPoints.getCarModelByBrand, queryParameters: {
      'brand': brand,
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarYearType(
      {required String brand, required String model}) {
    return api.get(EndPoints.getCarYearType, queryParameters: {
      'model': model,
      'brand': brand,
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> ridersColors() {
    return api.get("/ride/riders/colors");
  }

  Future<Either<Failure, Map<String, dynamic>>> getSigninUrl(
      {required String url, required Map<String, dynamic>? data}) {
    return api.put(url, data: data);
  }

  Future<Either<Failure, Map<String, dynamic>>> successUpload(
      {required String url, required Map<String, dynamic>? data}) {
    return api.put(url, data: data);
  }
}
