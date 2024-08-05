part of 'doctor_history_cubit.dart';

sealed class DoctorHistoryState extends Equatable {
  const DoctorHistoryState();

  @override
  List<Object> get props => [];
}

final class DoctorHistoryInitial extends DoctorHistoryState {}
