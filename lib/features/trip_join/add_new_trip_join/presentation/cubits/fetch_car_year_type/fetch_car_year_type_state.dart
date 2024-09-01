part of 'fetch_car_year_type_cubit.dart';

sealed class FetchCarYearTypeState {}

final class FetchCarYearTypeInitial extends FetchCarYearTypeState {}

final class FetchCarYearTypeLoading extends FetchCarYearTypeState {}

final class FetchCarYearTypeFailed extends FetchCarYearTypeState {
  final String message;

  FetchCarYearTypeFailed(this.message);
}

final class FetchCarYearTypeSuccess extends FetchCarYearTypeState {
  final List<CarYearTypeEntity> carYears;

  FetchCarYearTypeSuccess(this.carYears);
}
