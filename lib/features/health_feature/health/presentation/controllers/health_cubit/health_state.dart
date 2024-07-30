part of 'health_cubit.dart';

enum HealthStates { loading, initState, error }

class HealthState {
  final HealthStates status;
  final Failure? failure;
  final List<BookedAppointmentEntity>? myBookings;
  final List<SubCategoryModel>? subCategories;
  final List<SubCategoryModel>? medicalServices;
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
    List<SubCategoryModel>? subCategories,
    List<SubCategoryModel>? medicalServices,
  }) {
    return HealthState(
        status: status ?? this.status,
        medicalServices: medicalServices ?? this.medicalServices,
        failure: failure ?? this.failure,
        myBookings: myBookings ?? this.myBookings,
        subCategories: subCategories ?? this.subCategories);
  }
}
