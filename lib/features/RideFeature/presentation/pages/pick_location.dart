import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


import '../../../../res/style/app_colors.dart';

class AddressPickerWidget extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onAddressSelected;

  const AddressPickerWidget({super.key, required this.onAddressSelected});

  @override
  State<AddressPickerWidget> createState() => _AddressPickerWidgetState();
}

class _AddressPickerWidgetState extends State<AddressPickerWidget> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _streetController = TextEditingController();
  final _coordinatesController = TextEditingController();

  bool _isLoading = false;
  LatLng _mapCenter = const LatLng(30.0444, 31.2357); // Default to Cairo
  final MapController _mapController = MapController();
  double _zoom = 13.0;
  LatLng? _markerPosition;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _streetController.dispose();
    _coordinatesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        await Geolocator.openLocationSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission permanently denied")),
        );
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      _updateMapPosition(LatLng(position.latitude, position.longitude));
      await _reverseGeocode(LatLng(position.latitude, position.longitude));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMapPosition(LatLng position) {
    setState(() {
      _mapCenter = position;
      _markerPosition = position;
      _coordinatesController.text = "${position.latitude},${position.longitude}";
    });
    _mapController.move(position, _zoom);
  }

  Future<void> _reverseGeocode(LatLng point) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _cityController.text = p.locality ?? '';
          _regionController.text = p.administrativeArea ?? '';
          _streetController.text = p.street ?? '';
          _nameController.text = p.name ?? '';
        });
      }
    } catch (e) {
      debugPrint('Reverse geocode failed: $e');
    }
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _updateMapPosition(LatLng(location.latitude, location.longitude));
        await _reverseGeocode(LatLng(location.latitude, location.longitude));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Search failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText:LocaleKeys.searchForALocation.localize,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                  const SizedBox(height: 16),

                  // Map with controls
                  SizedBox(
                    height: 600,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: _mapCenter,
                            zoom: _zoom,
                            onTap: (tapPosition, point) {
                              _updateMapPosition(point);
                              _reverseGeocode(point);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            if (_markerPosition != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _markerPosition!,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _zoom += 1;
                                      _mapController.move(_mapCenter, _zoom);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      _zoom -= 1;
                                      _mapController.move(_mapCenter, _zoom);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.my_location),
                                  onPressed: _getCurrentLocation,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  AppButton(
                    backColor: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK :AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      if (_coordinatesController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(LocaleKeys.selectALocation.localize)),
                        );
                        return;
                      }

                      final address = {
                        'street': _streetController.text,
                        'city': _cityController.text,
                        'region': _regionController.text,
                        'coordinates': _coordinatesController.text,
                      };
                      widget.onAddressSelected(address);
                    },
                    label: LocaleKeys.confirm.localize,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           children: [
  //             // Search bar
  //             TextField(
  //               controller: _searchController,
  //               decoration: InputDecoration(
  //                 labelText: 'Search location',
  //                 suffixIcon: IconButton(
  //                   icon: const Icon(Icons.search),
  //                   onPressed: _searchLocation,
  //                 ),
  //               ),
  //               onSubmitted: (_) => _searchLocation(),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Map with controls
  //             SizedBox(
  //               height: 600,
  //               child: Stack(
  //                 children: [
  //                   FlutterMap(
  //                     mapController: _mapController,
  //                     options: MapOptions(
  //                       center: _mapCenter,
  //                       zoom: _zoom,
  //                       onTap: (tapPosition, point) {
  //                         _updateMapPosition(point);
  //                         _reverseGeocode(point);
  //                       },
  //                     ),
  //                     children: [
  //                       TileLayer(
  //                         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //                         userAgentPackageName: 'com.example.app',
  //                       ),
  //                       if (_markerPosition != null)
  //                         MarkerLayer(
  //                           markers: [
  //                             Marker(
  //                               point: _markerPosition!,
  //                               child: const Icon(
  //                                 Icons.location_pin,
  //                                 color: Colors.red,
  //                                 size: 40,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                     ],
  //                   ),
  //                   Positioned(
  //                     bottom: 10,
  //                     right: 10,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(4),
  //                       ),
  //                       padding: const EdgeInsets.all(4),
  //                       child: Column(
  //                         children: [
  //                           IconButton(
  //                             icon: const Icon(Icons.add),
  //                             onPressed: () {
  //                               setState(() {
  //                                 _zoom += 1;
  //                                 _mapController.move(_mapCenter, _zoom);
  //                               });
  //                             },
  //                           ),
  //                           IconButton(
  //                             icon: const Icon(Icons.remove),
  //                             onPressed: () {
  //                               setState(() {
  //                                 _zoom -= 1;
  //                                 _mapController.move(_mapCenter, _zoom);
  //                               });
  //                             },
  //                           ),
  //                           IconButton(
  //                             icon: const Icon(Icons.my_location),
  //                             onPressed: _getCurrentLocation,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             const SizedBox(height: 16),
  //             AppButton(
  //               backColor: AppColors.PRIMARY_COLOR,
  //               onPressed: () {
  //                 if (_coordinatesController.text.isEmpty) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text("Please select a location on the map")),
  //                   );
  //                   return;
  //                 }
  //
  //                 final address = {
  //                   'street': _streetController.text,
  //                   'city': _cityController.text,
  //                   'region': _regionController.text,
  //                   'coordinates': _coordinatesController.text,
  //                 };
  //                 widget.onAddressSelected(address);
  //               },
  //               label: 'Confirm Location',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}


