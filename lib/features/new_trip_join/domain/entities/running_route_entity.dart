import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class RunningRouteEntity{
  String? yourStatus;
  String? otp;
  num? youPay;
  MyBookingLocationEntity? pickUp;
  MyBookingLocationEntity? dropOff;
  List<List<double>>? currentPolyline;
  String? driverFirstName;
  String? driverProfilePicUrl;
  String? carPicturesUrl;
  String? plateInfo;
  String? isAccountVerified;
  String? vehicleBrandAr;
  String? vehicleBrandEn;
  String? vehicleModelAr;
  String? vehicleModelEn;
  String? vehicleColor;
  String? vehicleYear;
  String? phoneNumber;

  RunningRouteEntity({this.yourStatus,this.currentPolyline,phoneNumber,this.isAccountVerified,this.plateInfo,this.vehicleColor,this.vehicleYear,this.carPicturesUrl,this.otp,this.youPay,this.pickUp,this.dropOff,this.driverFirstName,this.driverProfilePicUrl,this.vehicleBrandAr,this.vehicleBrandEn,this.vehicleModelAr,this.vehicleModelEn});

}

