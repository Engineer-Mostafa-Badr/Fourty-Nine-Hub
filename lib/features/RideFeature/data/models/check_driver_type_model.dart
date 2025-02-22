import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';

class CheckDriverTypeModel extends CheckDriverTypeEntity{
  CheckDriverTypeModel({required super.shipping, required super.ride});

  factory CheckDriverTypeModel.fromJson(Map<String, dynamic> json) {
    return CheckDriverTypeModel(
      shipping: json['shipping'],
      ride: json['ride'],
    );
  }

}