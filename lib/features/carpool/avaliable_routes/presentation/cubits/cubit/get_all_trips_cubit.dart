import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GetAllTripsCubit extends Cubit<GetAllTripsState> {
  final Socket _socket;

  GetAllTripsCubit(this._socket) : super(GetAllTripsInitial()) {
    // Constructor body
    _initializeSocketListeners();
  }

  void _initializeSocketListeners() {
    // Connect the socket
    if (!_socket.connected) {
      _socket.connect();
      print("Socket connection initiated...");
    }

    // Listen for real-time trip updates from the server
    _socket.on('carpool:getAllTrip', (data) {
      print("Data received from server: $data");

      try {
        final trips = _parseTrips(data);
        emit(GetAllTripsSuccess(trips));
      } catch (e) {
        emit(GetAllTripsFailure('Parsing error: ${e.toString()}'));
      }
    });

    // Handle potential socket errors
    _socket.on('connect_error', (error) {
      print("Socket connection error: $error");
      emit(GetAllTripsFailure('Erorr happend . Please Try again: $error'));
    });

    _socket.on('disconnect', (data) {
      print('Socket disconnected: $data');
    });
  }

  void fetchAllCarpoolTrips() {
    _socket.connect();

    emit(GetAllTripsLoading());

    // Request the server to send the current list of carpool trips
    _socket.emit('carpool:getAllTrip');
  }

  // Parse the raw data from the socket into CarpoolTripParam objects
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

    return (data as List).map((tripData) {
      List<CarpoolLocation> locations = [];
      if (tripData['CARPOOL_LOCATIONS'] is List) {
        locations = (tripData['CARPOOL_LOCATIONS'] as List).map((loc) {
          return CarpoolLocation(
            id: loc['_id'],
            carpoolId: loc['carpoolId'],
            type: loc['type'],
            locationTitle: loc['locationTitle'],
            coordinates: LocationCoordinates(
              latitude: loc['location']?['coordinates']?[0] != null
                  ? loc['location']['coordinates'][0] as double
                  : null,
              longitude: loc['location']?['coordinates']?[1] != null
                  ? loc['location']['coordinates'][1] as double
                  : null,
            ),
            comfort: loc['comfort'] ?? false,
            booked: loc['booked'] ?? false,
            bookedUser: loc['bookedUser'] != null
                ? BookedUser(
                    id: loc['bookedUser']['_id'],
                    firstName: loc['bookedUser']['firstName'],
                    lastName: loc['bookedUser']['lastName'],
                    gender: loc['bookedUser']['gender'],
                  )
                : null,
          );
        }).toList();
      }

      return CarpoolTripParam(
        id: tripData['_id'],
        ownerId: tripData['ownerId'],
        seats: tripData['seats'],
        driverId: tripData['driverId'],
        driverStatus: tripData['driverStatus'],
        womenDriverOnly: tripData['womenDriverOnly'],
        womenOnly: tripData['womenOnly'],
        comfort: tripData['comfort'],
        tripStatus: tripData['tripStatus'],
        priceForEveryUser: tripData['priceForEveryUser'],
        priceForDriver: tripData['priceForDriver'],
        duration: tripData['duration'],
        distance: tripData['distance'],
        expireAt: DateTime.parse(tripData['expireAt']),
        createdAt: DateTime.parse(tripData['createdAt']),
        updatedAt: DateTime.parse(tripData['updatedAt']),
        locations: locations,
      );
    }).toList();
  }

  @override
  Future<void> close() {
    // Clean up the socket connection when the Cubit is closed
    _socket.dispose();
    return super.close();
  }
}
