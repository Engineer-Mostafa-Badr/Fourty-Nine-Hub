import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/complete_seat_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/verify_otp_param.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class VerifyOtpCompleteSeatDriverRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> verifyUserOtp(
      {required VerifyOtpParam verifyOtpParam, required String tripId});
  Future<Either<Failure, Map<String, dynamic>>> completeUserSeat({
    required CompleteSeatParam completeSeatParam,
  });
  Future<Either<Failure, CarpoolTripParam>> getAcceptedTrips();
}

class VerifyOtpCompleteSeatDriverRemoteDataSourceImp
    extends VerifyOtpCompleteSeatDriverRemoteDataSource {
  final ApiConsumer apiConsumer;

  VerifyOtpCompleteSeatDriverRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, Map<String, dynamic>>> completeUserSeat(
      {required CompleteSeatParam completeSeatParam}) async {
    const t =
        'VerifyOtpCompleteSeatDriverRemoteDataSourceImp - completeUserSeat ';
    final response = await apiConsumer.post(
      EndPoints.completeUserSeat,
      data: completeSeatParam.toMap(),
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr(data.toString(), t);
        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyUserOtp(
      {required VerifyOtpParam verifyOtpParam, required String tripId}) async {
    const t =
        'VerifyOtpCompleteSeatDriverRemoteDataSourceImp - completeUserSeat ';
    final response = await apiConsumer.put(
      EndPoints.verifyUserOtp(tripId),
      data: verifyOtpParam.toMap(),
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr(data.toString(), t);
        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, CarpoolTripParam>> getAcceptedTrips() async {
    const t = 'GetAcceptedTripsRemoteDataSourceImp - GetAcceptedTrips ';
    final response = await apiConsumer.get(
      EndPoints.getAcceptedTrips,
    );

    return response.fold(
      (failure) => Left(pr(failure, t)),
      (data) {
        pr(data.toString(), t);

        try {
          final trips = _parseTrips(data);

          return Right(trips);
        } catch (e) {
          pr('Parsing error: $e', t);
          return Left(UnknownFailure('Parsing error'));
        }
      },
    );
  }

  CarpoolTripParam _parseTrips(dynamic data) {
    if (data is String) {
      print("Received data as String, decoding...");
      String jsonString = data.replaceFirst('🚗 ', '').trim();
      print("Trimmed data: $jsonString");

      try {
        data = jsonDecode(jsonString);
      } catch (e) {
        print("Error decoding JSON: $e");
        throw Exception('Failed to decode JSON');
      }
    }

    if (data is! Map<String, dynamic>) {
      throw Exception(
          'Expected a Map<String, dynamic> but got ${data.runtimeType}');
    }

    // Extract the single trip from the "data" key
    final tripData = data['data'];
    if (tripData is! Map<String, dynamic>) {
      throw Exception(
          'Expected "data" to be a Map<String, dynamic> but got ${tripData.runtimeType}');
    }

    return _parseTrip(tripData);
  }

  CarpoolTripParam _parseTrip(Map<String, dynamic> tripData) {
    List<CarpoolLocation> locations = [];
    if (tripData['CARPOOL_LOCATIONS'] is List) {
      locations = (tripData['CARPOOL_LOCATIONS'] as List).map((loc) {
        return CarpoolLocation(
          id: loc['_id'] ?? '',
          carpoolId: loc['carpoolId'] ?? '',
          type: loc['type'] ?? '',
          locationTitle: loc['locationTitle'],
          coordinates: LocationCoordinates(
            latitude: loc['location']?['coordinates']?[0] as double?,
            longitude: loc['location']?['coordinates']?[1] as double?,
          ),
          comfort: loc['comfort'] ?? false,
          booked: loc['booked'] ?? false,
          otp: loc['OTP'] as String?,
          verifiedOtp: loc['verifiedOTP'] ?? false,
          gender: loc['gender'] as String?,
          tripStatusForUser: loc['tripStatusForUser'] as String?,
          bookedUser: loc['bookedUser'] != null
              ? BookedUser(
                  id: loc['bookedUser']['_id'] ?? '',
                  firstName: loc['bookedUser']['firstName'] ?? '',
                  lastName: loc['bookedUser']['lastName'] ?? '',
                  gender: loc['bookedUser']['gender'] ?? '',
                )
              : null,
        );
      }).toList();
    }

    return CarpoolTripParam(
      id: tripData['_id'] ?? '',
      ownerId: tripData['ownerId'] ?? '',
      subcategoryId: tripData['subcategoryId'] as String?,
      seats: (tripData['seats'] ?? 0).toInt(),
      driverId: tripData['driverId'] as String?,
      driverStatus: tripData['driverStatus'] as String?,
      womenDriverOnly: tripData['womenDriverOnly'] ?? false,
      womenOnly: tripData['womenOnly'] ?? false,
      comfort: tripData['comfort'] ?? false,
      tripStatus: tripData['tripStatus'] as String?,
      priceForEveryUser: (tripData['priceForEveryUser'] ?? 0).toDouble(),
      priceForDriver: (tripData['priceForDriver'] ?? 0).toDouble(),
      duration: (tripData['duration'] ?? 0).toInt(),
      distance: (tripData['distance'] ?? 0).toInt(),
      polyline: tripData['polyline'] as String?,
      expireAt: DateTime.parse(tripData['expireAt']),
      createdAt: DateTime.parse(tripData['createdAt']),
      updatedAt: DateTime.parse(tripData['updatedAt']),
      locations: locations,
    );
  }
}
