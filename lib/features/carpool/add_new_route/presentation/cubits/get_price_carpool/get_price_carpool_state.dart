part of 'get_price_carpool_cubit.dart';

sealed class GetPriceCarpoolState {}

final class GetPriceCarpoolInitial extends GetPriceCarpoolState {}

final class GetPriceCarpoolLoading extends GetPriceCarpoolState {}

final class GetPriceCarpoolFailed extends GetPriceCarpoolState {
  final String message;

  GetPriceCarpoolFailed(this.message);
}

final class GetPriceCarpoolSuccess extends GetPriceCarpoolState {
  final CarpoolRouteInfoModel carpoolRouteInfoModel;

  GetPriceCarpoolSuccess(this.carpoolRouteInfoModel);
}
