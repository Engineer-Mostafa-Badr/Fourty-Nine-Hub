import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/helpers/web_socket_helper.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/datasources/rider_data_source.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/offer_data_model/offer_data_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_response_model/trip_response_model.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

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
    // await socket.socket.connect();
    // tripSoketOn();
    return dataSource.requestTrip(model: model);
  }

  setSubCateogryId({required String subCategoryId}) {
    var data = jsonEncode({
      "subcategoryId": subCategoryId,
      "address":
          "٧٣ شارع أحمد عيسى من، شجرة مريم، قسم المطرية، محافظة  4532331، مصر"
    });
    socket.socket.io.emit("subcategory:driver", [data]);
  }

  updateDriverLocationEmit() {
    var data = jsonEncode({
      "location": [12, 21],
      "driverId": "string",
      "subcategoryId": "string",
    });

    socket.socket.io.emit("driver:location", [data]);
    socket.socket.io.on(
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
    socket.socket.io.on(
      "driver:location",
      (data) {
        log(data.toString());
        updateDriverLocationEmit();
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
    socket.socket
        .emit("trip:updatePrice", jsonEncode({"offer": offer, tripId: tripId}));
  }

  Future<Either<Failure, Map<String, dynamic>>> acceptOfferRide(
      {required String tripId, required String subCategory}) {
    return dataSource.acceptOfferRide(tripId: tripId, subCategory: subCategory);
  }

  Future<Either<Failure, Map<String, dynamic>>> declineOfferRide(
      {required String tripId}) {
    return dataSource.declineOfferRide(tripId: tripId);
  }

  void tripSoketOn(Function(OfferDataModel data) onData) {
    log("llllllllllllllllllllllllllllllllllllllllllllllllllll");
    socket.socket.on(
      "Ride:sendOffer",
      (data) {
        OfferDataModel model = OfferDataModel.fromJson(jsonDecode(data));

        onData(model);
        log("llllllllllllllllllllllllllllllllllllllllllllllllllll");
        log(jsonDecode(data).toString(),
            name: "llllllllllllllllllllllllllllllllllllllllllllllllllll");
      },
    );
    // return data;
  }

  List<TripResponseModel> getAllTripRider() {
    List<TripResponseModel> list = [];
    socket.socket.emit("Ride:getAllTrip");
    socket.socket.on(
      "Ride:getAllTrip",
      (data) {
        log(data.toString(), name: "lksdjfkdjjdjdjdjdjdjdjdjdjjddddd");
        List response = jsonDecode(extractTextAfterSymbol(data, '[')) ?? [];
        for (var element in response) {
          list.add(TripResponseModel.fromJson(element));
        }
      },
    );
    return list;
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
  // Future<List<LatLng>> getRoute({required LatLng start, required LatLng end}) {
  //   return dataSource.getRoute(start: start, end: end);
  // }
}

// Future<Either<Failure, Map<String, dynamic>>>