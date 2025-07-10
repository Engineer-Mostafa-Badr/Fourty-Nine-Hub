import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class RunningRouteEntity{
  String? yourStatus;
  num? youPay;
  MyBookingLocationEntity? pickUp;
  MyBookingLocationEntity? dropOff;
  String? driverFirstName;
  String? driverProfilePicUrl;
  String? vehicleBrandAr;
  String? vehicleBrandEn;
  String? vehicleModelAr;
  String? vehicleModelEn;

  RunningRouteEntity({this.yourStatus,this.youPay,this.pickUp,this.dropOff,this.driverFirstName,this.driverProfilePicUrl,this.vehicleBrandAr,this.vehicleBrandEn,this.vehicleModelAr,this.vehicleModelEn});

}

