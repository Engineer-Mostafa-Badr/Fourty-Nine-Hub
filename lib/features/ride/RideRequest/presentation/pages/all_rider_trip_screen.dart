import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_all_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_expired_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_route_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/google_map_tracking.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AllRiderTripScreen extends StatefulWidget {
  const AllRiderTripScreen({super.key});

  @override
  State<AllRiderTripScreen> createState() => _AllRiderTripScreenState();
}

class _AllRiderTripScreenState extends State<AllRiderTripScreen> {
  // TextEditingController newOfferPrice = TextEditingController();

  // late MapboxMapController mapController;

  // final LatLng _initialLocation = LatLng(-2121.97362,
  //               22.7676);
  // // Cairo coordinates
  // final String mapboxAccessToken =
  //     'sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg';
  // // ضع هنا مفتاح Mapbox API الخاص بك
  // Future<void> _onMapCreated(MapboxMapController controller) async {
  //   mapController = controller;
  //   final ByteData bytes = await rootBundle.load('assets/icons/google_pin.png');
  //   final Uint8List list = bytes.buffer.asUint8List();

  //   // إضافة الصورة إلى Mapbox
  //   await mapController.addImage('google_pin', list);

  //   _addMarkers(); // إضافة النقاط (Markers) عند تحميل الخريطة
  //   _drawRoute(LatLng(30.0444, 31.2357), LatLng(30.0456, 30.2368));
  // }

  // void _addMarkers() {
  //   mapController.addSymbol(
  //     SymbolOptions(
  //       geometry: LatLng(-2121.97362,
  //               22.7676), // إحداثيات القاهرة
  //       iconImage: "google_pin", // شكل الأيقونة (تحقق من وجودها)
  //       iconSize: 0.1, // حجم الأيقونة
  //       textField: 'نقطة 1', // النص الذي يظهر بجانب النقطة
  //       textOffset: Offset(0, 2), // موضع النص بالنسبة للأيقونة
  //       iconAnchor: "bottom",
  //     ),
  //   );

  //   // موقع آخر في القاهرة: النقطة الثانية
  //   mapController.addSymbol(
  //     SymbolOptions(
  //       geometry: LatLng(31.261392, 29.962565), // موقع آخر في القاهرة
  //       iconImage: "google_pin",
  //       iconSize: 0.1,
  //       textField: 'نقطة 2',
  //       textOffset: Offset(0, 2),
  //       iconAnchor: "bottom",
  //     ),
  //   );
  //   // mapController.addLine(
  //   //   LineOptions(
  //   //     geometry: [
  //   //       LatLng(30.0444, 31.2357),
  //   //       LatLng(30.0456, 30.2368),
  //   //     ],
  //   //     lineColor: "#FF0000",
  //   //     lineWidth: 2,
  //   //   ),
  //   // );
  // }

  // void _drawRoute(LatLng start, LatLng end) async {
  //   // Fetch the route from Mapbox Directions API
  //   List<LatLng> route = await context
  //       .read<GetRouteRiderCubit>()
  //       .getRoute(start: start, end: end);

  //   // Draw the route as a polyline on the map
  //   mapController.addLine(
  //     LineOptions(
  //       geometry: route,
  //       lineColor: "#007AFF", // لون الخط (أزرق هنا)
  //       lineWidth: 5.0, // عرض الخط
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMapTracking(
        startLocation: LatLng(30.108829,  31.315524),
        endLocation: LatLng(30.04429180472622, 31.192951490187284),
      ),
    );
  }

  // return DefaultTabController(
  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // إذا كان العدد يساوي أو أكبر من ساعة (3600 ثانية)
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      // إذا كان العدد يساوي أو أكبر من دقيقة (60 ثانية)
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes min, $seconds s';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }
}
