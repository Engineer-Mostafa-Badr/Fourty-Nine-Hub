import 'package:fourtyninehub/features/new_trip_join/data/models/my_booking_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RunningRouteModel extends RunningRouteEntity{
  RunningRouteModel(
      {super.yourStatus,
        super.currentPolyline,
        super.carPicturesUrl,
        super.plateInfo,
        super.isAccountVerified,
        super.phoneNumber,
        super.driverLastName,
        super.vehicleColorAr,
        super.waitingTime,
        super.routeId,
        super.vehicleColorEn,
        super.vehicleYear,
        super.otp,super.youPay,super.pickUp,super.dropOff,super.driverFirstName,super.driverProfilePicUrl,super.vehicleBrandAr,super.vehicleBrandEn,super.vehicleModelAr,super.vehicleModelEn});


  factory RunningRouteModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> parsedPolyline = [];

    if (json['location'] != null && json['location']['currentPolyline'] != null) {
      if (json['location']['currentPolyline'] is String) {
        // Decode the encoded polyline string
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decoded = polylinePoints.decodePolyline(
          json['location']['currentPolyline'] as String,
        );
        parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      } else if (json['location']['currentPolyline'] is List) {
        // Use the list directly
        parsedPolyline = (json['location']['currentPolyline'] as List)
            .map((e) => (e as List).map((p) => (p as num).toDouble()).toList())
            .toList();
      }
    }
    return RunningRouteModel(
      yourStatus: json['yourStatus'] ?? '',
      routeId: json['routeId'] ?? '',
      youPay: json['youPay'] ?? '',
      waitingTime: json['waitingTime'] ?? '',
      otp: json['otp'] ?? '',
      pickUp: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['pickUp']):null,
      dropOff: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['dropOff']):null,
      currentPolyline: parsedPolyline,
      driverFirstName: json['driverDetails']!=null?json['driverDetails']['firstName']??'':'',
      driverLastName: json['driverDetails']!=null?json['driverDetails']['lastName']??'':'',
      driverProfilePicUrl: json['driverDetails']!=null?json['driverDetails']['profilePicUrl']??'':'',
      carPicturesUrl: json['driverDetails']!=null?json['driverDetails']['carPicturesUrl']??'':'',
      plateInfo: json['driverDetails']!=null?json['driverDetails']['plateInfo']??'':'',
      isAccountVerified: json['driverDetails']!=null?json['driverDetails']['isAccountVerified']??false:false,
      phoneNumber: json['driverDetails']!=null?json['driverDetails']['phoneNumber']??'':'',
      vehicleBrandAr: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['brandAr']??'':'':'',
      vehicleBrandEn: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['brandEn']??'':'':'',
      vehicleModelAr: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['modelAr']??'':'':'',
      vehicleModelEn: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['modelEn']??'':'':'',
      vehicleYear: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['year']??0:0:0,
      vehicleColorAr: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['color']['nameAr']??'':'':'',
      vehicleColorEn: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['color']['nameEn']??'':'':'',
    );
  }

}

