import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart' as http;

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
  final String? allowedCountryCode;
  final String baseUri;

  const RideGoogleMapSearchAndPickParams({
    required this.onPicked,
    this.minAllowedDistanceKm = 1.5,
    this.minDistanceReferencePoint,
    this.allowedCountryCode = 'EG',
    this.baseUri = 'https://nominatim.openstreetmap.org',
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
  late GoogleMapController _controller;

  LatLng? _selectedLatLng;
  String _address = '';
  bool _isLoading = false;

  LatLng _initialPosition = const LatLng(30.0444, 31.2357); // Cairo default

  // Map to store country names in English and Arabic
  static const Map<String, Map<String, String>> _countryNames = {
    'eg': {'en': 'Egypt', 'ar': 'مصر'},
    'us': {'en': 'USA', 'ar': 'أمريكا'},
    'my': {'en': 'Malaysia', 'ar': 'ماليزيا'},
    'ae': {'en': 'UAE', 'ar': 'الإمارات'},
    'sa': {'en': 'Saudi Arabia', 'ar': 'السعودية'},
  };

  @override
  void initState() {
    super.initState();
    // fetchUserLocation();
  }

  String _getCountryName(String? countryCode, BuildContext context) {
    if (countryCode == null) {
      return context.isArabic ? 'المنطقة المدعومة' : 'the supported region';
    }
    final country = _countryNames[countryCode.toLowerCase()];
    if (country == null) {
      return context.isArabic ? 'هذه المنطقة' : 'this region'; // Fallback if country code not found
    }
    return context.isArabic ? country['ar']! : country['en']!;
  }

  Future<bool> isLocationAllowed(double lat, double lon) async {
    if (widget.params.allowedCountryCode == null) {
      return true; // No country code specified, all locations allowed
    }

    try {
      final url =
          '${widget.params.baseUri}/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1';
      log(url);
      final response = await http.get(Uri.parse(url));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      final countryCode = decoded['address']?['country_code'];

      return countryCode?.toString().toLowerCase() ==
          widget.params.allowedCountryCode!.toLowerCase();
    } catch (e) {
      debugPrint('Error checking location: $e');
      return false;
    }
  }

  Future<void> fetchUserLocation() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation =
      GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      _moveToLocation(position.latitude, position.longitude);
      _onMapTap(LatLng(position.latitude, position.longitude));
    } catch (e) {
      log('_fetchUserLocation ${e.toString()}');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(" permanently denied$permission");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Position(
        longitude: 31.235457277186548,
        latitude: 30.047873322617807,
        timestamp: DateTime.now(),
        accuracy: 0.2,
        altitude: 0.5,
        altitudeAccuracy: 0.6,
        heading: 0.2,
        headingAccuracy: 0.1,
        speed: 20,
        speedAccuracy: 10,
      );
    }
    if (permission == LocationPermission.denied) {
      print("objectLocation permissions are permanently denied");
      return Position(
        longitude: 31.235457277186548,
        latitude: 30.047873322617807,
        timestamp: DateTime.now(),
        accuracy: 0.2,
        altitude: 0.5,
        altitudeAccuracy: 0.6,
        heading: 0.2,
        headingAccuracy: 0.1,
        speed: 20,
        speedAccuracy: 10,
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _setInitialPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Show a message to the user
        setState(() {
          _selectedLatLng = _initialPosition;
        });
        return;
      }
    }
    try {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        _initialPosition = LatLng(pos.latitude, pos.longitude);
        _selectedLatLng = _initialPosition;
      });
    } catch (_) {
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
          _searchController.text = address;
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

  Future<void> _applyMapStyle(BuildContext context) async {
    final lightStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/light_map_style.json');
    final darkStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/dark_map_style.json');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    await _controller.setMapStyle(isDark ? darkStyle : lightStyle);

    fetchUserLocation();
  }

  Future<void> _handleLocationSelection() async {
    if (_selectedLatLng == null) return;

    setState(() {
      _isLoading = true;
    });

    final lat = _selectedLatLng!.latitude;
    final lon = _selectedLatLng!.longitude;

    // Check if location is allowed (country validation)
    final isAllowed = await isLocationAllowed(lat, lon);

    if (!isAllowed) {
      if (mounted) {
        final String countryName = _getCountryName(
            widget.params.allowedCountryCode, context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: context.isDarkMode
                ? AppColors.QUANTITY_COLOR
                : Colors.white,
            title: Text(
              context.isArabic
                  ? "الموقع غير مدعوم"
                  : "Location not supported",
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
            ),
            content: Text(
              context.isArabic
                  ? "حالياً التطبيق متاح فقط داخل $countryName."
                  : "The app is currently available only in $countryName.",
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.isArabic ? "إغلاق" : "Close",
                ),
              ),
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Distance check
    if (widget.params.minDistanceReferencePoint != null &&
        widget.params.minAllowedDistanceKm > 0) {
      final double distanceInMeters = Geolocator.distanceBetween(
        widget.params.minDistanceReferencePoint!.latitude,
        widget.params.minDistanceReferencePoint!.longitude,
        lat,
        lon,
      );
      final double distanceInKm = distanceInMeters / 1000;

      if (distanceInKm < widget.params.minAllowedDistanceKm) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: context.isDarkMode
                  ? AppColors.QUANTITY_COLOR
                  : Colors.white,
              title: Text(
                context.isArabic
                    ? "المسافة صغيرة جداً"
                    : "Distance too short",
                style: TextStyle(
                    color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
              ),
              content: Text(context.isArabic
                  ? "أقل مسافة متاحة هي ${widget.params.minAllowedDistanceKm} كيلومتر."
                  : "The minimum allowed distance is ${widget.params.minAllowedDistanceKm} kilometers."),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.isArabic ? "إغلاق" : "Close",
                  ),
                ),
              ],
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // All validations passed, proceed with location selection
    setState(() {
      _isLoading = false;
    });

    widget.params.onPicked(
      PickedData(
        address: _address,
        latitude: lat,
        longitude: lon,
      ),
    );
  }

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 24.6),
    northeast: const LatLng(31.75, 35.0),
  );

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
                  onMapCreated: (controller) {
                    _controller = controller;
                    _mapController.complete(controller);
                    _applyMapStyle(context);
                  },
                  initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
                  onTap: _onMapTap,
                  markers: _selectedLatLng != null
                      ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLatLng!,
                      infoWindow: InfoWindow(
                        title: _address,
                      ),
                    )
                  }
                      : {},
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  cameraTargetBounds: widget.params.allowedCountryCode?.toLowerCase() == 'eg'
                      ? CameraTargetBounds(egyptBounds)
                      : CameraTargetBounds.unbounded,
                ),

                // Search Bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(8),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _searchController,
                      itemBuilder: (context, index, prediction) {
                        return Container(
                          color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey[200],
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  prediction.description ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: context.isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      googleAPIKey: "AIzaSyDQqf_i02Uh6HoNp46HJnCr7_LIjrnLCuc",
                      inputDecoration: InputDecoration(
                        hintText: context.isArabic ? 'ابحث عن موقع' : 'Search for a location...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      debounceTime: 800,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        _moveToLocation(double.tryParse((prediction.lat ?? '0')) ?? 0,
                            double.tryParse((prediction.lng ?? '0')) ?? 0);
                      },
                      itemClick: (prediction) {
                        print("prediction.description ${prediction.description}");
                        _searchController.text = prediction.description!;
                        _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      },
                      countries: widget.params.allowedCountryCode != null
                          ? [widget.params.allowedCountryCode!.toLowerCase()]
                          : const ["eg"],
                    ),
                  ),
                ),

                if (_isLoading) const Center(child: CircularProgressIndicator()),

                // Set Location Button
                Positioned(
                  bottom: 20,
                  left: 70,
                  right: 70,
                  child: ElevatedButton(
                    onPressed: _selectedLatLng == null
                        ? null
                        : _handleLocationSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      context.isArabic ? 'تعيين الموقع' : 'Set Location',
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