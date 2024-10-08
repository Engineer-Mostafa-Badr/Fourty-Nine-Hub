import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class RiderDataSource {
  final ApiConsumer api;

  RiderDataSource({required this.api});

  Future<Either<Failure, Map<String, dynamic>>> getCateogryData() {
    return api
        .get("${EndPoints.bannerDataRider}?userId=66c349d7a684ab473f1c1ed7");
  }

  Future<Either<Failure, Map<String, dynamic>>> registerDriver(
      {required RiderRegisterModel model}) {
    return api.post(EndPoints.specialRegister, data: model.registerOne());
  }

  Future<Either<Failure, Map<String, dynamic>>> riderRegister(
      {required RiderRegisterModel model}) {
    return api.post(EndPoints.riderRegister, data: model.registerTow());
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripInfo(
      {required GetTripInfoRequestModel model}) {
    return api.post("${EndPoints.expectedPrice}/${model.subCateogryId}",
        data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> pictureOptional() {
    return api.get(EndPoints.pictureOptional);
  }

  Future<Either<Failure, Map<String, dynamic>>> requestTrip(
      {required TripRequestModel model}) {
    return api.post("${EndPoints.newTripRide}/62c8ba9f8e28a58a3edf57eb", data: {
      "price": 125,
      "fromTitle":
          "5 القنال، معادي السرايات الغربية، قسم المعادي، محافظة القاهرة 4212220، مصر",
      "toTitle":
          "19 شارع دمنهور، البستان، قسم مصر الجديدة، محافظة القاهرة 4460313، مصر",
      "distance": 25708,
      "duration": 2304,
      "startLocation": [31.261392, 29.962565],
      "targetLocation": [30.098281, 31.329383],
      "calculate_b": 0,
      "paymentMethod": "cash",
      "passengers": 4,
      "comfort": true,
      "autoAccept": false,
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

  Future<List<LatLng>> getRoute(
      {required LatLng start, required LatLng end}) async {
    const String accessToken =
        'sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg';
    final String url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$accessToken';
    final response = await http.get(Uri.parse(url));
    log(response.body.toString(), name: "lskdjflskdjfsldkdddkdkdkdkdkd");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coordinates = data['routes'][0]['geometry']['coordinates'];

      // Convert the coordinates to LatLng
      return coordinates.map((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}
