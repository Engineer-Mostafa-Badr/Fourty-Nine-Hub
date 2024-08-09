part of 'doctor_statistics_cubit.dart';

sealed class DoctorStatisticsState {}

final class DoctorStatisticsInitial extends DoctorStatisticsState {}

final class DoctorStatisticsLoading extends DoctorStatisticsState {}

final class DoctorStatisticsLoaded extends DoctorStatisticsState {
  final DoctorStatisticsEntity statistics;
  DoctorStatisticsLoaded(this.statistics);
}

final class DoctorStatisticsError extends DoctorStatisticsState {
  final String message;
  DoctorStatisticsError(this.message);
}
