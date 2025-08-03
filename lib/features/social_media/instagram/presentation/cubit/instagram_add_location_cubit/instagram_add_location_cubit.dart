
import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/location_instagram_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'instagram_add_location_state.dart';

class InstagramAddLocationCubit extends Cubit<InstagramAddLocationState> {
  InstagramAddLocationCubit() : super(const InstagramAddLocationState());

  // void addLocationInstagram(context) async {
  //   // if(state.place!=null||(state.place?.name.isEmpty??false)){
  //   //   context.read<CreatePostCubit>().removeAddress();
  //   // }else{
  //   LocationInstagramEntity address = await fetchLocationAndAddress(context);
  //   if (address.name.isNotEmpty) {
  //     // context.read<CreatePostCubit>().setAddress(address);
  //     // sheetController.collapse();
  //   }
  //   // }
  // }

  void removeLocation() {
    emit(const InstagramAddLocationState());
  }

  Future<void> fetchLocationAndAddress() async {
    try {
      // showLoadingDialog(context);
      emit(state.copyWith(
        status: InstagramAddLocationStates.loading,
      ));
      LocationInstagramEntity address = await _getLocationAddress();
      print("Location Address: ${address.toMap()}");
      // context.pop();
      emit(
        state.copyWith(
          status: InstagramAddLocationStates.success,
          location: address,
        )
      );
      // return address;
    } catch (e) {
      emit(
        state.copyWith(
          status: InstagramAddLocationStates.failure,
          failure: UnknownFailure(e.toString()),
        ),
      );
      // print(e);
      // context.pop();
      // return LocationInstagramEntity(formattedAddress: '', name: '', lat:0, lng: 0);
    }
  }

  Future<LocationInstagramEntity> _getLocationAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      print("✅ Location permission granted.");
    } else if (status.isDenied) {
      print("❌ Location permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Location permission permanently denied. Open settings.");
      await openAppSettings();
    }
    // Check location permission status
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // When permissions are granted, fetch the current position
    Position position = await Geolocator.getCurrentPosition();

    // Get address from latitude and longitude
    String address = await _getAddress(position.latitude, position.longitude);
    LocationInstagramEntity selectedPlace = LocationInstagramEntity(
        formattedAddress: address,
        name: address,
        lat: position.latitude,
        lng: position.longitude);
    return selectedPlace;
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    try {
      // Get the placemark (address) from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      // context.pop();

      // If there are placemarks (addresses) available
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print("place.street${place.street}");
        print("place.locality${place.locality}");
        print("place.country${place.country}");
        print("place.street${place.street}");
        return "${place.locality}, ${place.administrativeArea}, ${place.country}";
        // context.pop();
      } else {
        // context.pop();
        return "No address found";
      }
    } catch (e) {
      // context.pop();
      return "Error: $e";
    }
  }
}
