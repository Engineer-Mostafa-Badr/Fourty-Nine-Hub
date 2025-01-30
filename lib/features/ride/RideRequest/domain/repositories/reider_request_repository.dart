import 'dart:async';
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
import 'package:fourtyninehub/features/ride/RideRequest/data/models/current_trip_ride_model/current_trip_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_near_by_model/driver_near_by_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rating_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
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
    SharedWebSocket.socket?.emit("Ride:getAllTrip");
    return dataSource.requestTrip(model: model);
  }

  setSubCateogryId({required String subCategoryId, required String address}) {
    log(address, name: "sldkjflskdjflskdjflskdjflskdjf");
    var data = jsonEncode({"subcategoryId": subCategoryId, "address": address});
    log(data.toString());
    SharedWebSocket.socket?.emit("subcategory:driver", data);
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
    SharedWebSocket.socket?.emit("driver:location", data);
    SharedWebSocket.socket?.on(
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
    // SharedWebSocket.socket?.emit("driver:location");
    SharedWebSocket.socket?.on(
      "driver:location",
      (data) {
        log(data.toString(),
            name:
                "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll123123");
        var extractTextAfter = extractTextAfterSymbol(data, "{");
        var json = jsonDecode(extractTextAfter);
        SharedWebSocket.socket?.off("driver:location");
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
      "location": location,
      "subcategoryId": "62c8ba9f8e28a58a3edf57eb",
      "tripId": "66f0cb0681573362b3c41e18"
    });
    SharedWebSocket.socket?.emit("drivers:nearBy", [data]);
  }

  riseFare({required String offer, required String tripId}) {
    var json = jsonEncode({"offer": offer, "tripId": tripId});
    log(json.toString(), name: "riseFare");
    SharedWebSocket.socket?.emit(
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
    SharedWebSocket.socket?.on(
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
    SharedWebSocket.socket?.on("trip:updatePrice", (data) {
      getAllTripSocket((data) {});
    });
  }

  void getAllTripSocket(Function(List<AllTripForDriverModel> data) onData) {
    log("llllllllllllllllllllllllllllllllllllllllllllllllllll getAllTrip");
    SharedWebSocket.socket?.emit("Ride:getAllTrip");
    SharedWebSocket.socket?.on(
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
        log(model.toString(), name: "AllTripAllTrip");
        onData(model);
      },
    );
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
    SharedWebSocket.socket?.on(
      "Ride:acceptTripFromDriver",
      (data) {
        var json = jsonDecode(data);
        log(data.toString(), name: "Ride:acceptTripFromDriver");
        SharedWebSocket.socket?.emit("Ride:currentTrip");
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
    SharedWebSocket.socket?.on(
      "Ride:acceptTripOfferFromClient",
      (data) {
        SharedWebSocket.socket?.emit("Ride:currentTrip");
        var json = jsonDecode(data);
        log(data.toString(), name: "Ride:acceptTripOfferFromClient");
        CheckAcceptByRiderModel model = CheckAcceptByRiderModel.fromJson(json);
        log(data.toString(), name: "Ride:acceptTripOfferFromClient");
        onData(model);
      },
    );
  }

  checkTripEnd({required Function() check}) {
    log("lksdjflskdjflskjdflskjdlfksjdlfjsldkfjsldkjflskdjflskjdf");
    SharedWebSocket.socket?.on(
      "Ride:endTrip",
      (data) {
        log("lksdjflskdjflskjdflskjdlfksjdlfjsldkfjsldkjflskdjflskjdf ok");
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

  Future<Either<Failure, Map<String, dynamic>>> recordVoiceRide(
      {required String tripId, required String mediaId}) {
    return dataSource.recordVoiceRide(mediaId: mediaId, tripId: tripId);
  }

  Future<Either<Failure, Map<String, dynamic>>> confirmUpload(
      {required String mediaId}) {
    return dataSource.confirmUpload(mediaId: mediaId);
  }

  Future<Either<Failure, Map<String, dynamic>>> mediaUrl({
    required String type,
    required int size,
    required String subcategoryId,
  }) {
    return dataSource.mediaUrl(
        size: size, subcategoryId: subcategoryId, type: type);
  }

  Future<Either<Failure, Map<String, dynamic>>> getDriverInfo() {
    return dataSource.getDriverInfo();
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteDriver() {
    return dataSource.deleteDriver();
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarBrand() {
    return dataSource.getCarBrand();
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarModelByBrand(
      {required String brand}) {
    return dataSource.getCarModelByBrand(brand: brand);
  }

  Future<Either<Failure, Map<String, dynamic>>> getCarYearType(
      {required String brand, required String model}) {
    return dataSource.getCarYearType(model: model, brand: brand);
  }

  Future<Either<Failure, Map<String, dynamic>>> ridersColors() {
    return dataSource.ridersColors();
  }

  checkStartRecord(Function() onChage) {
    log("Ride:startRecord i");
    SharedWebSocket.socket?.on(
      "Ride:startRecord",
      (data) {
        log("Ride:startRecord");
        onChage();
      },
    );
  }

  checkStopRecord(Function() onChage) {
    SharedWebSocket.socket?.on(
      "Ride:stopRecord",
      (data) {
        onChage();
      },
    );
  }

  currentTrip(Function(CurrentTripRideModel model) onChage) {
    log("lsdjflskdjflskdjflskdjflskdjf");
    SharedWebSocket.socket?.emit("Ride:currentTrip");
    SharedWebSocket.socket?.on(
      "Ride:currentTrip",
      (data) {
        log(data.toString(), name: "lsdjflskdjflskdjflskdjflskdjf");
        onChage(CurrentTripRideModel.fromJson(jsonDecode(data)));
        SharedWebSocket.socket?.off("Ride:currentTrip");
      },
    );
  }

  // stopSocket(){
  //   so
  // }

  driversNearBy({
    required String tripId,
    required List location,
    required String subcategoryId,
    required String address,
    required Function(List<DriverNearByModel> model) onChange,
  }) {
    log("Starting driversNearBy...");
    List oldDriver = [];
    var dataJson = jsonEncode({
      "subcategoryId": subcategoryId,
      "address": address,
      "oldDrivers": oldDriver,
      "location": location,
      "tripId": tripId,
    });
    SharedWebSocket.socket?.emit("drivers:nearBy", dataJson);
    Timer? timer = Timer.periodic(const Duration(seconds: 25), (timer) {
      SharedWebSocket.socket?.emit("drivers:nearBy", dataJson);
      log("Emit triggered: $dataJson");
    });
    SharedWebSocket.socket?.on(
      "Ride:stopSearch",
      (data) {
        timer.cancel();
      },
    );
    List<DriverNearByModel> allData = [];
    SharedWebSocket.socket?.on(
      "drivers:nearBy",
      (data) {
        List dataList = jsonDecode(data);
        allData = dataList.map((e) => DriverNearByModel.fromJson(e)).toList();
        oldDriver = allData.map((e) => e.driverId).toList();
        log(oldDriver.toString(), name: "oldDriver");
        dataJson = jsonEncode({
          "subcategoryId": subcategoryId,
          "address": address,
          "oldDrivers": oldDriver,
          "location": location,
          "tripId": tripId,
        });
        onChange(allData);
        log(data.toString(), name: "Drivers NearBy Data");
      },
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getSignUrl(
      {required Map<String, dynamic>? data, required String url}) {
    return dataSource.getSigninUrl(url: url, data: data);
  }

  Future<Either<Failure, Map<String, dynamic>>> successUpload(
      {required Map<String, dynamic>? data, required String url}) {
    return dataSource.successUpload(url: url, data: data);
  }
  Future<Either<Failure, Map<String, dynamic>>> getRideDriver() {
    return dataSource.getRideDriver();
  }
}
