import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class PickedData {
  final String address;
  final double latitude;
  final double longitude;

  PickedData({required this.address, required this.latitude, required this.longitude});
}

class RideGoogleMapSearchAndPickParams {
  final void Function(PickedData) onPicked;
  final double minAllowedDistanceKm;
  final latlong.LatLng? minDistanceReferencePoint;

  const RideGoogleMapSearchAndPickParams({
    required this.onPicked,
    this.minAllowedDistanceKm = 1.5,
    this.minDistanceReferencePoint,
  });
}

class RideGoogleMapSearchAndPick extends StatefulWidget {
  final RideGoogleMapSearchAndPickParams params;
  const RideGoogleMapSearchAndPick({super.key, required this.params});

  @override
  State<RideGoogleMapSearchAndPick> createState() => _RideMapPickerState();
}

class _RideMapPickerState extends State<RideGoogleMapSearchAndPick> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedLatLng;
  String _address = '';
  bool _isLoading = false;

  LatLng _initialPosition = const LatLng(30.0444, 31.2357); // Cairo default

  @override
  void initState() {
    super.initState();
    _setInitialPosition();
  }

  Future<void> _setInitialPosition() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        _initialPosition = LatLng(pos.latitude, pos.longitude);
        _selectedLatLng = _initialPosition;
      });
    } catch (_) {
      // fallback to default
      _selectedLatLng = _initialPosition;
    }
  }

  Future<void> _onMapTap(LatLng latLng) async {
    setState(() {
      _selectedLatLng = latLng;
      _isLoading = true;
    });

    try {
      List<geo.Placemark> places = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (places.isNotEmpty) {
        final place = places.first;
        final address = '${place.street}, ${place.locality}, ${place.country}';
        setState(() {
          _address = address;
        });
      }
    } catch (_) {}

    setState(() {
      _isLoading = false;
    });
  }

  bool _isWithinMinDistance() {
    if (widget.params.minDistanceReferencePoint == null || _selectedLatLng == null) return true;

    final distance = latlong.Distance().as(
      latlong.LengthUnit.Kilometer,
      latlong.LatLng(_selectedLatLng!.latitude, _selectedLatLng!.longitude),
      widget.params.minDistanceReferencePoint!,
    );

    return distance >= widget.params.minAllowedDistanceKm;
  }

  Future<void> _moveToLocation(double lat, double lng) async {
    final GoogleMapController controller = await _mapController.future;
    final position = LatLng(lat, lng);
    controller.animateCamera(CameraUpdate.newLatLng(position));
    _onMapTap(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: NestedAppbar(
            scrollController: ScrollController(),
            appBars: const [],
            body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => _mapController.complete(controller),
                  initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
                  onTap: _onMapTap,
                  markers: _selectedLatLng != null
                      ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLatLng!,
                      infoWindow: InfoWindow(
                        title: context.isArabic ? 'الموقع المحدد' : 'Selected Location',
                      ),
                    )
                  }
                      : {},
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                ),

                // 🔍 Search Bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _searchController,
                      itemBuilder: (context, index,prediction) {
                        return Container(
                          color: Colors.grey[200], // 👈 Change this to any color you want
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  prediction.description ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      googleAPIKey: "AIzaSyDQqf_i02Uh6HoNp46HJnCr7_LIjrnLCuc", // replace with your key
                      inputDecoration: InputDecoration(
                        hintText: context.isArabic ? 'ابحث عن موقع' : 'Search for a location...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      debounceTime: 800,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        _moveToLocation(double.tryParse((prediction.lat??'0'))??0, double.tryParse((prediction.lng??'0'))??0);
                      },
                      itemClick: (prediction) {
                        _searchController.text = prediction.description!;
                        _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      },
                      countries: const ["eg"], // optional filter by country
                    ),
                  ),
                ),

                if (_isLoading) const Center(child: CircularProgressIndicator()),

                // 📍 Set Location Button
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _selectedLatLng == null || !_isWithinMinDistance()
                        ? null
                        : () {
                      widget.params.onPicked(
                        PickedData(
                          address: _address,
                          latitude: _selectedLatLng!.latitude,
                          longitude: _selectedLatLng!.longitude,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      context.isArabic ? 'تعيين الموقع المحدد' : 'Set Selected Location',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
