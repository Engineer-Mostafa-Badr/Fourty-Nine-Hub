// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fourtyninehub/common/widgets/OpenStreetMapSearchAndPick/widgets/wide_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../res/style/app_colors.dart';

class OpenStreetMapSearchAndPick extends StatefulWidget {
  final void Function(PickedData pickedData) onPicked;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final IconData currentLocationIcon;
  final IconData locationPinIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color locationPinIconColor;
  final String locationPinText;
  final TextStyle locationPinTextStyle;
  final String buttonText;
  final String hintText;
  final double buttonHeight;
  final double buttonWidth;
  final TextStyle buttonTextStyle;
  final String baseUri;
  final LatLng? minDistanceReferencePoint;
  final double minAllowedDistanceKm;
  final String? allowedCountryCode;

  const OpenStreetMapSearchAndPick({
    super.key,
    required this.onPicked,
    this.zoomOutIcon = Icons.zoom_out_map,
    this.zoomInIcon = Icons.zoom_in_map,
    this.currentLocationIcon = Icons.my_location,
    this.buttonColor = Colors.blue,
    this.locationPinIconColor = Colors.blue,
    this.locationPinText = 'Location',
    required this.locationPinTextStyle,
    this.hintText = 'Search Location',
    this.buttonTextStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    this.buttonTextColor = Colors.white,
    this.buttonText = 'Set Current Location',
    this.buttonHeight = 50,
    this.buttonWidth = 200,
    this.baseUri = 'https://nominatim.openstreetmap.org',
    this.locationPinIcon = Icons.location_on,
    this.minDistanceReferencePoint, // Initialize the new parameters
    this.minAllowedDistanceKm =
        0,
    this.allowedCountryCode = 'EG',
  });

  @override
  State<OpenStreetMapSearchAndPick> createState() =>
      _OpenStreetMapSearchAndPickState();
}

class _OpenStreetMapSearchAndPickState
    extends State<OpenStreetMapSearchAndPick> {
  MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  Timer? _debounce;
  var client = http.Client();
  late Future<Position?> latlongFuture;
  bool isLoading = false; // Moved to the state class

  // Map to store country names in English and Arabic
  static const Map<String, Map<String, String>> _countryNames = {
    'eg': {'en': 'Egypt', 'ar': 'مصر'},
    'us': {'en': 'USA', 'ar': 'أمريكا'},
    'my': {'en': 'Malaysia', 'ar': 'ماليزيا'},
    'ae': {'en': 'UAE', 'ar': 'الإمارات'},
    'sa': {'en': 'Saudi Arabia', 'ar': 'السعودية'},
    // Add more countries as needed
  };

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
    if (widget.allowedCountryCode == null) {
      return true; // No country code specified, all locations allowed
    }

    try {
      final url =
          '${widget.baseUri}/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1';
      log(url);
      final response = await http.get(Uri.parse(url));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      final countryCode = decoded['address']?['country_code'];

      return countryCode?.toString().toLowerCase() ==
          widget.allowedCountryCode!.toLowerCase();
    } catch (e) {
      debugPrint('Error checking location: $e');
      return false;
    }
  }

  Future<Position?> getCurrentPosLatLong() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    /// do not have location permission
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      return await getPosition(locationPermission);
    }

    /// have location permission
    Position position = await Geolocator.getCurrentPosition();
    setNameCurrentPosAtInit(position.latitude, position.longitude);
    return position;
  }

  Future<Position?> getPosition(LocationPermission locationPermission) async {
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      return null;
    }
    Position position = await Geolocator.getCurrentPosition();
    setNameCurrentPosAtInit(position.latitude, position.longitude);
    return position;
  }

  void setNameCurrentPos() async {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }
    String url =
        '${widget.baseUri}/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';
    log(url);

    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }

  void setNameCurrentPosAtInit(double latitude, double longitude) async {
    if (kDebugMode) {
      print(latitude);
    }
    if (kDebugMode) {
      print(longitude);
    }

    String url =
        '${widget.baseUri}/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';
    log(url);
    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    log(response.body);
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
  }

  @override
  void initState() {
    _mapController = MapController();

    _mapController.mapEventStream.listen(
      (event) async {
        if (event is MapEventMoveEnd) {
          var client = http.Client();
          String url =
              '${widget.baseUri}/reverse?format=json&lat=${event.camera.center.latitude}&lon=${event.camera.center.longitude}&zoom=18&addressdetails=1';
          log(url);
          var response = await client.get(Uri.parse(url));
          // var response = await client.post(Uri.parse(url));
          var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<dynamic, dynamic>;

          _searchController.text = decodedResponse['display_name'];
          setState(() {});
        }
      },
    );

    latlongFuture = getCurrentPosLatLong();

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String? _autocompleteSelection;
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: widget.buttonColor.withValues(alpha: 0.5), width: 1),
      borderRadius: BorderRadius.circular(10.0),
    );
    OutlineInputBorder inputFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(
          color: widget.buttonColor.withValues(alpha: 0.5), width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    );
    return FutureBuilder<Position?>(
      future: latlongFuture,
      builder: (context, snapshot) {
        LatLng? mapCentre;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          mapCentre = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
        }
        return SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: FlutterMap(
                    options: MapOptions(
                        center: mapCentre, zoom: 15.0, maxZoom: 18, minZoom: 6),
                    mapController: _mapController,
                    children: [
                      TileLayer(
                        urlTemplate: context.isDarkMode
                            ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark mode map
                            : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", // Normal mode map
                        subdomains: const ['a', 'b', 'c'],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.locationPinText,
                              style: widget.locationPinTextStyle,
                              textAlign: TextAlign.center),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Icon(
                              widget.locationPinIcon,
                              size: 50,
                              color: widget.locationPinIconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 180,
                  right: 5,
                  child: FloatingActionButton(
                    heroTag: 'btn1',
                    backgroundColor: widget.buttonColor,
                    onPressed: () {
      ManageVibration.vibrate();
                      _mapController.move(
                          _mapController.center, _mapController.zoom + 1);
                    },
                    child: Icon(
                      widget.zoomInIcon,
                      color: widget.buttonTextColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  right: 5,
                  child: FloatingActionButton(
                    heroTag: 'btn2',
                    backgroundColor: widget.buttonColor,
                    onPressed: () {
      ManageVibration.vibrate();
                      _mapController.move(
                          _mapController.center, _mapController.zoom - 1);
                    },
                    child: Icon(
                      widget.zoomOutIcon,
                      color: widget.buttonTextColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 5,
                  child: FloatingActionButton(
                    heroTag: 'btn3',
                    backgroundColor: widget.buttonColor,
                    onPressed: () async {
      ManageVibration.vibrate();
                      if (mapCentre != null) {
                        _mapController.move(
                            LatLng(mapCentre.latitude, mapCentre.longitude),
                            _mapController.zoom);
                      } else {
                        _mapController.move(
                            LatLng(50.5, 30.51), _mapController.zoom);
                      }
                      setNameCurrentPos();
                    },
                    child: Icon(
                      widget.currentLocationIcon,
                      color: widget.buttonTextColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              border: inputBorder,
                              focusedBorder: inputFocusBorder,
                            ),
                            onChanged: (String value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }

                              _debounce = Timer(
                                  const Duration(milliseconds: 300), () async {
                                if (kDebugMode) {
                                  print(value);
                                }
                                var client = http.Client();
                                try {
                                  // String url =
                                  //     '${widget.baseUri}/search?q=$value&format=json&polygon_geojson=1&addressdetails=1&countrycodes=eg';

                                  String url =
                                      '${widget.baseUri}/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                                  if (widget.allowedCountryCode != null) {
                                    url += '&countrycodes=${widget.allowedCountryCode!.toLowerCase()}';
                                  }
                                  if (kDebugMode) {
                                    print(url);
                                  }
                                  var response =
                                      await client.get(Uri.parse(url));
                                  // var response = await client.post(Uri.parse(url));
                                  var decodedResponse = jsonDecode(
                                          utf8.decode(response.bodyBytes))
                                      as List<dynamic>;
                                  if (kDebugMode) {
                                    print(decodedResponse);
                                  }
                                  _options = decodedResponse
                                      .map(
                                        (e) => OSMdata(
                                          displayname: e['display_name'],
                                          lat: double.parse(e['lat']),
                                          lon: double.parse(e['lon']),
                                        ),
                                      )
                                      .toList();
                                  setState(() {});
                                } finally {
                                  client.close();
                                }

                                setState(() {});
                              });
                            }),
                        StatefulBuilder(
                          builder: ((context, setState) {
                            return Container(
                              decoration: BoxDecoration(
                                color: context.isDarkMode
                                    ? AppColors.QUANTITY_COLOR
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    _options.length > 6 ? 6 : _options.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    tileColor: context.isDarkMode
                                        ? AppColors.QUANTITY_COLOR
                                        : Colors.white,
                                    textColor: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    title: Text(_options[index].displayname,
                                        style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        )),
                                    subtitle: Text(
                                        '${_options[index].lat},${_options[index].lon}',
                                        style: TextStyle(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                        )),
                                    onTap: () {
      ManageVibration.vibrate();
                                      _mapController.move(
                                          LatLng(_options[index].lat,
                                              _options[index].lon),
                                          15.0);

                                      _focusNode.unfocus();
                                      _options.clear();
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              color: AppColors.PRIMARY_COLOR_DARK,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: WideButton(
                              widget.buttonText,
                              textStyle: widget.buttonTextStyle,
                              height: widget.buttonHeight,
                              width: widget.buttonWidth,
                              onPressed: () async {
      ManageVibration.vibrate();
                                setState(() {
                                  isLoading = true;
                                });
                                final lat = _mapController.center.latitude;
                                final lon = _mapController.center.longitude;

                                final isAllowed =
                                await isLocationAllowed(lat, lon);

                                if (!isAllowed) {
                                  if (context.mounted) {
                                    final String countryName = _getCountryName(
                                        widget.allowedCountryCode, context);
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
                                          style:  TextStyle(
                                              color: context.isDarkMode? Colors.white :  AppColors.PRIMARY_COLOR),
                                        ),
                                        content: Text(
                                          context.isArabic
                                              ? "حالياً التطبيق متاح فقط داخل $countryName."
                                              : "The app is currently available only in $countryName.",
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors
                                                  .PRIMARY_COLOR_DARK, // خلفية الزر
                                              foregroundColor:
                                                  Colors.white, // لون النص
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              context.isArabic
                                                  ? "إغلاق"
                                                  : "Close",
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return;
                                }

                                // New: Distance check
                                if (widget.minDistanceReferencePoint != null &&
                                    widget.minAllowedDistanceKm > 0) {
                                  final double distanceInMeters =
                                      Geolocator.distanceBetween(
                                    widget.minDistanceReferencePoint!.latitude,
                                    widget.minDistanceReferencePoint!.longitude,
                                    lat,
                                    lon,
                                  );
                                  final double distanceInKm =
                                      distanceInMeters / 1000;

                                  if (distanceInKm <
                                      widget.minAllowedDistanceKm) {
                                    if (context.mounted) {
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
                                            style:  TextStyle(
                                                color: context.isDarkMode? Colors.white :  AppColors.PRIMARY_COLOR),
                                          ),
                                          content: Text(context.isArabic
                                              ? "أقل مسافة متاحة هي ${widget.minAllowedDistanceKm} كيلومتر."
                                              : "The minimum allowed distance is ${widget.minAllowedDistanceKm} kilometers."),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors
                                                    .PRIMARY_COLOR_DARK, // خلفية الزر
                                                foregroundColor:
                                                    Colors.white, // لون النص
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                context.isArabic
                                                    ? "إغلاق"
                                                    : "Close",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                }

                                final value = await pickData();
                                setState(() {
                                  isLoading = false;
                                });
                                widget.onPicked(value);
                              },
                              backgroundColor: widget.buttonColor,
                              foregroundColor: widget.buttonTextColor,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> isLocationInEgypt(double lat, double lon) async {
    try {
      final url =
          '${widget.baseUri}/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1';
      log(url);
      final response = await http.get(Uri.parse(url));
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      final countryCode = decoded['address']?['country_code'];

      return countryCode?.toString().toLowerCase() == 'eg';
    } catch (e) {
      debugPrint('Error checking location: $e');

      return false;
    }
  }

  Future<PickedData> pickData() async {
    LatLong center = LatLong(
        _mapController.center.latitude, _mapController.center.longitude);
    var client = http.Client();
    String url =
        '${widget.baseUri}/reverse?format=json&lat=${_mapController.center.latitude}&lon=${_mapController.center.longitude}&zoom=18&addressdetails=1';
    log(url);

    var response = await client.get(Uri.parse(url));
    // var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    String displayName = decodedResponse['display_name'];
    return PickedData(center, displayName, decodedResponse["address"]);
  }
}

class OSMdata {
  final String displayname;
  final double lat;
  final double lon;
  OSMdata({required this.displayname, required this.lat, required this.lon});
  @override
  String toString() {
    return '$displayname, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMdata && other.displayname == displayname;
  }

  @override
  int get hashCode => Object.hash(displayname, lat, lon);
}

class LatLong {
  final double latitude;
  final double longitude;
  const LatLong(this.latitude, this.longitude);
}

class PickedData {
  final LatLong latLong;
  final String addressName;
  final Map<String, dynamic> address;

  PickedData(this.latLong, this.addressName, this.address);
}
