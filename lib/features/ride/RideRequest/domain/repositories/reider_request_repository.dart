import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/datasources/rider_data_source.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_for_driver_mode/all_trip_for_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_offer_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_trip_ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rating_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_offer_model/trip_request_offer_model.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';

class ReiderRequestRepository {
  final RiderDataSource dataSource;
  final WebSocketHelper socket;
  ReiderRequestRepository({required this.dataSource, required this.socket});
  Future<Either<Failure, Map<String, dynamic>>> getCateogry() {
    return dataSource.getCateogryData();
  }

  Future<Either<Failure, Map<String, dynamic>>> registerDriver(
      {required RiderRegisterModel model}) {
    return dataSource.registerDriver(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> riderRegister(
      {required RiderRegisterModel model}) {
    return dataSource.riderRegister(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripInfo(
      {required GetTripInfoRequestModel model}) {
    return dataSource.getTripInfo(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> pictureOptional() {
    return dataSource.pictureOptional();
  }

  Future<Either<Failure, Map<String, dynamic>>> request(
      {required TripRequestModel model}) async {
    socket.socket.emit("Ride:getAllTrip");
    return dataSource.requestTrip(model: model);
  }

  setSubCateogryId({required String subCategoryId, required String address}) {
    log(address, name: "sldkjflskdjflskdjflskdjflskdjf");
    var data = jsonEncode({"subcategoryId": subCategoryId, "address": address});
    log(data.toString());
    socket.socket.emit("subcategory:driver", data);
    updateDriverLocationOn();
    log(subCategoryId, name: "sldkjflskdjflskdjflskdjflskdjf");
  }

  updateDriverLocationEmit(
      {required String driverId, required String subCategoryId}) async {
    Position location = await Geolocator.getCurrentPosition();
    var data = jsonEncode({
      "location": [location.latitude, location.longitude],
      "driverId": driverId,
      "subcategoryId": subCategoryId,
    });
    log(data.toString(), name: "ldksjflskdjflksjdfkdkdkdkdk");
    socket.socket.emit("driver:location", data);
    socket.socket.on(
      "driver:location",
      (data) {
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
        log(data.toString(), name: "lllllllllllllllllllllll");
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
      },
    );
  }

  updateDriverLocationOn() {
    log("lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll123123");
    // socket.socket.emit("driver:location");
    socket.socket.on(
      "driver:location",
      (data) {
        log(data.toString(),
            name:
                "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll123123");
        var extractTextAfter = extractTextAfterSymbol(data, "{");
        var json = jsonDecode(extractTextAfter);
        socket.socket.off("driver:location");
        log(json.toString(), name: "driver:location");
        updateDriverLocationEmit(
            driverId: json['driverId'],
            subCategoryId: json['subcategoryId'].toString());
      },
    );
  }

  nearbyDriversEmit(
      {required List location,
      required String subcategoryId,
      required String tripId}) {
    var data = jsonEncode({
      "location": [31.261392, 29.962565],
      "subcategoryId": "62c8ba9f8e28a58a3edf57eb",
      "tripId": "66f0cb0681573362b3c41e18"
    });
    socket.socket.emit("drivers:nearBy", [data]);
  }
//   RequestSocketResponse nearbyDriversOn() {
//     Map<String, dynamic> response = {};
//     socket.socket.on(
//       "drivers:near",
//       (data) {
//         log(jsonDecode(data).toString(),
//             name: "lskdjflsdkjflskdjflkdjflskdjflskdjf");
//         // response = jsonDecode(fixJson(data));
//       },
//     );
//     response = jsonDecode('''{
//   "drivers": [
//     {
//       "driverId": "66e0578c51f4bced71f262d1",
//       "location": {
//         "lat": "null",
//         "lng": "0"
//       },
//       "userData": {
//         "firstName": "basel",
//         "USER_PROFILE": {
//           "_id": "66c349d7a684ab473f1c1eda",
//           "userId": "66c349d7a684ab473f1c1ed7",
//           "profilePictureKey": {
//             "_id": "66a4ee09e0f15662b542e239",
//             "mediaKey": "https://49hub-reels.s3.eu-central-1.amazonaws.com/ride/twitter/66a4118c8a30f11ecd8f9edd/eeed6270-6a1c-4d76-a3ed-4bb015e1160c.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240923%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240923T052212Z&X-Amz-Expires=3600&X-Amz-Signature=f28c44970b10310cfc4b991981955afe15c80fb5dc16eb40757fa4815c605c4d&X-Amz-SignedHeaders=host&x-id=GetObject"
//             }
//           },
//           "id": "null"
//         }
//       },
//       {
//         "driverId": "66e0582a66fc44ca4acb327d",
//         "location": {
//           "lat": "null",
//           "lng": "0"
//       },
//       "userData": {
//         "firstName": "mohamed",
//         "USER_PROFILE": {
//           "_id": "66bcbd183aa2f0e6b120aa6e",
//           "userId": "66bcbd183aa2f0e6b120aa6b",
//           "profilePictureKey": {
//             "_id": "66cc740113bfa607c5bbcb82",
//             "mediaKey": "https://49hub-reels.s3.eu-central-1.amazonaws.com/ride/pickup/66bcbd183aa2f0e6b120aa6b/ef686290-4c9e-4515-afcd-f7c8a19c8975.jpeg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240923%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240923T052212Z&X-Amz-Expires=3600&X-Amz-Signature=ea301251d5a196f59f797c368c4553b14dd19fad23115a2229ed406741531cc8&X-Amz-SignedHeaders=host&x-id=GetObject"
//           }
//         },
//       "id": "null"
//     }
//   }
// ], "tripInfo": {
//   "distance": 25708,
//   "duration": 2304,
//   "price": 125,
//   "paymentMethod": "cash"
// }
// }''');
//     log(response.toString(), name: "lskdjflskdjflskdjflkdjjfjfjfjfjffj");
//     RequestSocketResponse data = RequestSocketResponse.fromJson(response);
//     return data;
//   }

  riseFare({required String offer, required String tripId}) {
    var json = jsonEncode({"offer": offer, "tripId": tripId});
    log(json.toString(), name: "riseFare");
    socket.socket.emit(
      "trip:updatePrice",
      json,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptOfferRide(
      {required String tripId, required String subCategory}) {
    return dataSource.acceptOfferRide(tripId: tripId, subCategory: subCategory);
  }

  Future<Either<Failure, Map<String, dynamic>>> declineOfferRide(
      {required String tripId}) {
    return dataSource.declineOfferRide(tripId: tripId);
  }

  void tripSoketOn(Function(TripRequestOfferModel data) onData) {
    log("llllllllllllllllllllllllllllllllllllllllllllllllllll kkkkkkk");
    socket.socket.on(
      "Ride:sendOffer",
      (data) {
        log("llllllllllllllllllllllllllllllllllllllllllllllllllll");
        TripRequestOfferModel model =
            TripRequestOfferModel.fromJson(jsonDecode(data));
        onData(model);
        log("llllllllllllllllllllllllllllllllllllllllllllllllllll");
        log(jsonDecode(data).toString(),
            name:
                "llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
      },
    );
    // return data;
  }

  void updatePriceOn() {
    socket.socket.on("trip:updatePrice", (data) {
      getAllTripSocket((data) {});
    });
  }

  void getAllTripSocket(Function(List<AllTripForDriverModel> data) onData) {
    log("llllllllllllllllllllllllllllllllllllllllllllllllllll getAllTrip");
    socket.socket.connect();
    socket.socket.emit("Ride:getAllTrip");
    socket.socket.on(
      "Ride:getAllTrip",
      (data) {
        updatePriceOn();
        log(data.toString(), name: "jdflksjdflksjdlfkjdkjfjfjfjfjfkdkdkkd");
        List<AllTripForDriverModel> model =
            (jsonDecode(extractTextAfterSymbol(data, '[')) as List)
                .map(
                  (e) => AllTripForDriverModel.fromJson(e),
                )
                .toList();
        // AllTripForDriverModel.fromJson(jsonDecode(data));
        log(model.toString(), name: "AllTripAllTrip");
        onData(model);
        // log("llllllllllllllllllllllllllllllllllllllllllllllllllll");
        // log(jsonDecode(data).toString(),
        //     name: "llllllllllllllllllllllllllllllllllllllllllllllllllll");
      },
    );
    // return data;
  }

  String extractTextAfterSymbol(String text, String symbol) {
    int startIndex = text.indexOf(symbol);
    if (startIndex != -1) {
      return text.substring(startIndex);
    } else {
      return 'Symbol not found';
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> expiredTrip() {
    return dataSource.getExpairedTrip();
  }

  Future<Either<Failure, Map<String, dynamic>>> checkDriverType() {
    return dataSource.checkDriverType();
  }

  Future<Either<Failure, Map<String, dynamic>>> createRequest(
      {required CreateTripRideRequestModel model}) {
    return dataSource.createRequest(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> createRequestPremium(
      {required CreateTripRideRequestModel model}) {
    return dataSource.createRequestPremium(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> getAddressFromLatAndLong(
      {required String address}) {
    return dataSource.getAddressFromLatAndLong(address: address);
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptTripByDriver(
      {required String id}) {
    return dataSource.acceptTripByDriver(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> createOfferByDriver(
      {required String id, required double price}) {
    return dataSource.createOfferByDriver(id: id, price: price);
  }

  checkAcceptByDriver(
      {required Function(CheckAcceptTripFromDriverModel model) onData}) {
    log("triiiiiiiiiiiiiiiiiiiiiiiiiiiiip Driver");
    socket.socket.on(
      "Ride:acceptTripFromDriver",
      (data) {
        var json = jsonDecode(data);
        log(data.toString(), name: "Ride:acceptTripFromDriver");
        var model =
            CheckAcceptTripFromDriverModel.fromJson(json['acceptedTrip']);
        model.otp = json['OTP'];
        onData(model);
        log(data.toString(), name: "Ride:acceptTripFromDriver");
      },
    );
  }

  checkAcceptByRider(
      {required Function(CheckAcceptByRiderModel model) onData}) {
    log("triiiiiiiiiiiiiiiiiiiiiiiiiiiiip Rider");
    socket.socket.on(
      "Ride:acceptTripOfferFromClient",
      (data) {
        var json = jsonDecode(data);
        log(data.toString(), name: "Ride:acceptTripOfferFromClient");
        CheckAcceptByRiderModel model = CheckAcceptByRiderModel.fromJson(json);
        log(data.toString(), name: "Ride:acceptTripOfferFromClient");
        onData(model);
      },
    );
  }

  checkTripEnd({required Function() check}) {
    socket.socket.on(
      "Ride:endTrip",
      (data) {
        log(data.toString());
        check();
      },
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> riderInStartLocation(
      {required String id}) {
    return dataSource.riderInStartLocation(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> startTripRider(
      {required String id, required int otp}) {
    return dataSource.startTripRider(id: id, otp: otp);
  }

  Future<Either<Failure, Map<String, dynamic>>> partialPayment({
    required String id,
    required double amount,
    required String paymentMethod,
  }) {
    return dataSource.partialPayment(
        id: id, amount: amount, paymentMethod: paymentMethod);
  }

  Future<Either<Failure, Map<String, dynamic>>> completedTripRider(
      {required String id}) {
    return dataSource.completedTripRider(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelTripClient(
      {required String id, String? reasonId, String? note}) {
    return dataSource.cancelTripClient(id: id, note: note, reasonId: reasonId);
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelTripRider(
      {required String reasonId, required String note, required String id}) {
    return dataSource.cancelTripRider(id: id, note: note, reasonId: reasonId);
  }

  Future<Either<Failure, Map<String, dynamic>>> reasons() {
    return dataSource.reasons();
  }

  Future<Either<Failure, Map<String, dynamic>>> checkPayment(
      {required String amount}) {
    return dataSource.checkPayment(amount: amount);
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllTripNoSocket(
      {required String id}) {
    return dataSource.getAllTripNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> createOfferNoSocket(
      {required CreateOfferNoSocketModel model, required String tripId}) {
    return dataSource.createOfferNoSocket(model: model, tripId: tripId);
  }

  Future<Either<Failure, Map<String, dynamic>>> offerAcceptNoSocket(
      {required String id}) {
    return dataSource.offerAcceptNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> offerRejectNoSocket(
      {required String id}) {
    return dataSource.offerRejectNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripOffersNoSocket(
      {required String id}) {
    return dataSource.getTripOffersNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> getUserLoginTripNoSocket() {
    return dataSource.getUserLoginTripNoSocket();
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteTripNoSocket(
      {required String id}) {
    return dataSource.deleteTripNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> completeTripNoSocket(
      {required String id}) {
    return dataSource.completeTripNoSocket(id: id);
  }

  Future<Either<Failure, Map<String, dynamic>>> rating(
      {required RattingDriverModel model}) {
    return dataSource.rating(model: model);
  }
}
