part of 'health_cubit.dart';

enum HealthStates { loading, initState, error }

class HealthState {
  final HealthStates status;
  final Failure? failure;
  final List<AppointmentBookingEntity>? myBookings;
  final List<SubCategoryModel>? subCategories;
  final isDoctor = false;
  const HealthState(
      {this.status = HealthStates.loading, this.failure, this.myBookings, this.subCategories});
  HealthState copyWith({
    HealthStates? status,
    Failure? failure,
    List<AppointmentBookingEntity>? myBookings,
    List<SubCategoryModel>? subCategories,
  }) {
    return HealthState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        myBookings: myBookings ?? this.myBookings, 
        subCategories: subCategories?? this.subCategories
        );
  }
}
