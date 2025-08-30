import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class RunningRouteEntity{
  String? yourStatus;
  String? otp;
  String? routeId;
  num? youPay;
  MyBookingLocationEntity? pickUp;
  MyBookingLocationEntity? dropOff;
  List<List<double>>? currentPolyline;
  String? driverFirstName;
  String? driverLastName;
  String? driverProfilePicUrl;
  String? carPicturesUrl;
  String? plateInfo;
  String? waitingTime;
  bool? isAccountVerified;
  String? vehicleBrandAr;
  String? vehicleBrandEn;
  String? vehicleModelAr;
  String? vehicleModelEn;
  String? vehicleColorAr;
  String? vehicleColorEn;
  num? vehicleYear;
  String? phoneNumber;

  RunningRouteEntity({this.routeId,this.yourStatus,this.currentPolyline,this.waitingTime,this.driverLastName,phoneNumber,this.isAccountVerified,this.plateInfo,this.vehicleColorAr,this.vehicleColorEn,this.vehicleYear,this.carPicturesUrl,this.otp,this.youPay,this.pickUp,this.dropOff,this.driverFirstName,this.driverProfilePicUrl,this.vehicleBrandAr,this.vehicleBrandEn,this.vehicleModelAr,this.vehicleModelEn});

}

