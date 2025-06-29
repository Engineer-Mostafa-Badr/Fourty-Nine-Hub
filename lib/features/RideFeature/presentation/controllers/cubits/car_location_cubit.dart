import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../domain/entities/get_location_from_address_entity.dart';

class CarLocationCubit extends Cubit<GetLocationFromAddressEntity?> {
  CarLocationCubit() : super(null) {
    startCarLocationTracking();
  }

  StreamSubscription<Position>? _carLocationStream;

  void startCarLocationTracking() {
    _carLocationStream?.cancel();

    _carLocationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((position) async {
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final address = placemarks.isNotEmpty
            ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
            : "Unknown car location";

        final carLocation = GetLocationFromAddressEntity(
          lat: position.latitude,
          lng: position.longitude,
          address: address,
        );
        log('CarLocation Stream: $carLocation');
        emit(carLocation);
      } catch (e) {
        log('CarLocation Stream Error: ${e.toString()}');
      }
    });
  }

  void stopCarLocationTracking() {
    _carLocationStream?.cancel();
    _carLocationStream = null;
  }

  @override
  Future<void> close() {
    stopCarLocationTracking();
    return super.close();
  }
}
