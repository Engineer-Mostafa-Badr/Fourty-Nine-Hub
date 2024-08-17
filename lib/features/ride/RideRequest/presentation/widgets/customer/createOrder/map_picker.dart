import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../helpers/BitmapDescriptor.dart';
import '../../../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../res/style/app_colors.dart';

class MapPicker extends StatefulWidget {
  final Function(CameraPosition)? onMoving;
  final Function(String)? onAddressPicked;
  final bool? showDoneButton;
  final double? lat, lng;
  final double? destLat, destLng;
  final bool? showCurrentLocation;
  final bool showAddress;

  const MapPicker({
    super.key,
    this.onMoving,
    this.lat,
    this.lng,
    this.destLat,
    this.destLng,
    this.showCurrentLocation,
    this.onAddressPicked,
    this.showDoneButton,
    this.showAddress = true,
  });
  @override
  State<MapPicker> createState() => _mapPickerState();
}

class _mapPickerState extends State<MapPicker> {
  GoogleMapController? mapController;
  String address = '';
  bool isMoving = false;
  CameraPosition? _camera;
  String mapKey = 'AIzaSyCSzHt1y3RDKvC2D67mF-WJdyZKE9hBIxA';
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (widget.lat != null &&
          widget.lng != null &&
          widget.destLat != null &&
          widget.destLng != null) {
        if (markers.isEmpty) {
          _addMarker(LatLng(widget.lat ?? 0, widget.lng ?? 0), "origin",
              await getCustomIcon(backColor: AppColors.PRIMARY_COLOR));

          _addMarker(LatLng(widget.destLat ?? 0, widget.destLng ?? 0),
              "destination", await getCustomIcon(backColor: Colors.red));
          _getPolyline();
        }
      }
    });

    super.initState();
  }

  Future<BitmapDescriptor> getCustomIcon({
    required Color backColor,
  }) async {
    return CircleAvatar(
      radius: 8,
      backgroundColor: backColor,
      child: const CircleAvatar(
        radius: 4,
        backgroundColor: Colors.white,
      ),
    ).toBitmapDescriptor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.LIGHT_GRAY_COLOR,
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
                zoomControlsEnabled: false,
                onCameraMove: (CameraPosition v) {
                  isMoving = true;
                  _camera = v;
                  setState(() {});
                  if (widget.onMoving != null && markers.isEmpty) {
                    // ignore: prefer_null_aware_method_calls
                    widget.onMoving!(v);
                  }
                },
                onCameraMoveStarted: () {},
                myLocationButtonEnabled: widget.showCurrentLocation ?? true,
                myLocationEnabled: widget.showCurrentLocation ?? true,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
                onCameraIdle: () async {
                  if (_camera != null) {
                    onMapMoving(_camera!);
                  }
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.lat ?? 30.7865086, widget.lng ?? 31.0003757),
                    zoom: 16)),
          ),
          if (widget.lat != null &&
              widget.lng != null &&
              widget.destLat != null &&
              widget.destLng != null)
            Positioned(
                bottom: 0, right: 0, left: 0, height: 0, child: Container())
          else
            Positioned.fill(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.showAddress)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(5)),
                      child: Label(
                          text: address,
                          style: Styles.mediumText(color: Colors.white)),
                    ),
                  const Sizer(),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    child: CircleAvatar(
                      radius: isMoving ? 10 : 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Container(
                    height: 15,
                    width: 2,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  if (isMoving)
                    const SizedBox()
                  else
                    const CircleAvatar(
                      radius: 5,
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    )
                ],
              ),
            )),
          if (widget.showDoneButton ?? false)
            Positioned(
                height: kToolbarHeight * .7,
                bottom: kToolbarHeight * 1.5,
                right: 10,
                left: 10,
                child: AppButton(label: 'Done', onPressed: () => context.pop()))
          else
            Positioned(
                bottom: 0, right: 0, left: 0, height: 0, child: Container()),
        ],
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: AppColors.PRIMARY_COLOR,
        width: 3,
        points: polylineCoordinates);
    polylines[id] = polyline;
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(widget.destLat!, widget.destLng!), zoom: 13)));
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(widget.lat ?? 0, widget.lng ?? 0),
        PointLatLng(widget.destLat ?? 0, widget.destLng ?? 0),
        travelMode: TravelMode.driving,
        wayPoints: []);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  void onMapMoving(CameraPosition position) async {
    isMoving = true;
    setState(() {});
    if (markers.isEmpty) {
      if (widget.showAddress) {
        final DioRequest = Dio(BaseOptions(
            baseUrl: 'https://maps.googleapis.com/maps/api/geocode',
            followRedirects: false));
        final result = await DioRequest.get(
            '/json?latlng=${position.target.latitude},${position.target.longitude}&key=$mapKey');
        address = result.data['results'][3]['formatted_address'].toString();
      }

      if (widget.onMoving != null) {
        // ignore: prefer_null_aware_method_calls
        widget.onMoving!(position);
      }
      if (widget.onAddressPicked != null) {
        // ignore: prefer_null_aware_method_calls
        widget.onAddressPicked!(address);
      }
    }

    isMoving = false;
    setState(() {});
  }
}
