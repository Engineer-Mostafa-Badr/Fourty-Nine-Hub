import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/id_s3_response_model/id_s3_response_model.dart';

class ShippingState {}

class ShippingInitial extends ShippingState {}

class SuccessGetBannerState extends ShippingState {
  final BannerModel model;

  SuccessGetBannerState({required this.model});
}

class FailureShippingState extends ShippingState {
  final String message;

  FailureShippingState({required this.message});
}

class SucccessGetIdS3 extends ShippingState {
  final IdS3ResponseModel model;

  SucccessGetIdS3({required this.model});
}
