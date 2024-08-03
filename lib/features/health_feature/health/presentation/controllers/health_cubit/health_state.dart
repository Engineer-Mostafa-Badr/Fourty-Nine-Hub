part of 'health_cubit.dart';

enum HealthStates { loading, initState, error }

class HealthState {
  final HealthStates status;
  final Failure? failure;
  final List<BookedAppointmentEntity>? myBookings;
  final List<HealthSubcategoryEntity>? subCategories;
  final List<HealthSubcategoryEntity>? medicalServices;
  final isDoctor = false;
  const HealthState(
      {this.status = HealthStates.loading,
      this.failure,
      this.myBookings,
      this.subCategories,
      this.medicalServices});
  HealthState copyWith({
    HealthStates? status,
    Failure? failure,
    List<BookedAppointmentEntity>? myBookings,
    List<HealthSubcategoryEntity>? subCategories,
    List<HealthSubcategoryEntity>? medicalServices,
  }) {
    return HealthState(
        status: status ?? this.status,
        medicalServices: medicalServices ?? this.medicalServices,
        failure: failure ?? this.failure,
        myBookings: myBookings ?? this.myBookings,
        subCategories: subCategories ?? this.subCategories);
  }
}
