import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GetAllTripsCubit extends Cubit<GetAllTripsState> {
  // final Socket SharedWebSocket.socket!;

  GetAllTripsCubit() : super(GetAllTripsInitial()) {
    _initializeSocketListeners();
  }

  void _initializeSocketListeners() {
    // if (!SharedWebSocket.instance.socket!.connected) {
    //   SharedWebSocket.instance.socket!.connect();
    //   print("Socket connection initiated...");
    // }

    SharedWebSocket.socket!.on('carpool:getAllTrip', (data) {
      print("Data received from server: $data");

      try {
        final trips = _parseTrips(data);
        emit(GetAllTripsSuccess(trips));
      } catch (e) {
        emit(GetAllTripsFailure('there is no trips try again'));
      }
    });

    SharedWebSocket.socket!.on('connect_error', (error) {
      print("there is no trips try again");
      emit(GetAllTripsFailure('there is no trips try again'));
    });

    SharedWebSocket.socket!.on('disconnect', (data) {
      print('Socket disconnected: $data');
    });
  }

  void fetchAllCarpoolTrips() {
    // SharedWebSocket.instance.socket!.connect();
    emit(GetAllTripsLoading());
    SharedWebSocket.socket!.emit('carpool:getAllTrip');
  }

  List<CarpoolTripParam> _parseTrips(dynamic data) {
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

    if (data is! List) {
      throw Exception('Expected a list of trips but got ${data.runtimeType}');
    }

    return (data).map((tripData) {
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
    }).toList();
  }

  @override
  Future<void> close() {
    // SharedWebSocket.instance.socket!.dispose();
    return super.close();
  }
}
