import 'package:fourtyninehub/features/new_trip_join/data/models/my_booking_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';

class RunningRouteModel extends RunningRouteEntity{
  RunningRouteModel(
      {super.yourStatus,super.youPay,super.pickUp,super.dropOff,super.driverFirstName,super.driverProfilePicUrl,super.vehicleBrandAr,super.vehicleBrandEn,super.vehicleModelAr,super.vehicleModelEn});


  factory RunningRouteModel.fromJson(Map<String, dynamic> json) {
    return RunningRouteModel(
      yourStatus: json['yourStatus'] ?? '',
      youPay: json['youPay'] ?? '',
      pickUp: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['pickUp']):null,
      dropOff: json['location']!=null?MyBookingLocationModel.fromJson(json['location']['dropOff']):null,
      driverFirstName: json['driverDetails']!=null?json['driverDetails']['firstName']??'':'',
      driverProfilePicUrl: json['driverDetails']!=null?json['driverDetails']['profilePicUrl']??'':'',
      vehicleBrandAr: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['brandAr']??'':'':'',
      vehicleBrandEn: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['brandEn']??'':'':'',
      vehicleModelAr: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['modelAr']??'':'':'',
      vehicleModelEn: json['driverDetails']!=null?json['driverDetails']['vehicle']!=null?json['driverDetails']['vehicle']['modelEn']??'':'':'',
    );
  }

}

