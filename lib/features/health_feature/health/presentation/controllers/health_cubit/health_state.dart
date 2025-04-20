part of 'health_cubit.dart';

enum HealthStates { loading, initState, error, success }

extension HealthStateX on HealthState {
  bool get isInitial => status == HealthStates.initState;
  bool get isLoading => status == HealthStates.loading;
  bool get isSuccess => status == HealthStates.success;
  bool get isError => status == HealthStates.error;
}

class HealthState {
  final HealthStates status;
  final Failure? failure;
  final List<BookedAppointmentEntity>? myBookings;
  final List<HealthSubcategoryEntity>? subCategories;
  final List<HealthSubcategoryEntity>? medicalServices;
  final List<GovernorateEntity>? governorates;
  final MainCategoryEntity? mainCategory;
  final Banner? banner;
  final bool? isDoctor;
  final bool? isApproved;
  final bool? isLoadingMoreBooking;
  final bool? isLoadingMoreMostBooking;
  final List<BookingEntity>? currentBookings;
  final List<BookingEntity>? historyBookings;
  final String? activeBookingType;
  final List<MostBookingEntity>? mostBooking;
  const HealthState({
    this.status = HealthStates.loading,
    this.failure,
    this.mainCategory,
    this.myBookings,
    this.isDoctor,
    this.isApproved,
    this.subCategories,
    this.medicalServices,
    this.governorates,
    this.banner,
    this.isLoadingMoreBooking,
     this.currentBookings,
     this.historyBookings,
     this.activeBookingType,
     this.mostBooking,
    this.isLoadingMoreMostBooking = false,
  });

  HealthState copyWith({
    HealthStates? status,
    Failure? failure,
    bool? isDoctor,
    bool? isApproved,
    MainCategoryEntity? mainCategory,
    List<BookedAppointmentEntity>? myBookings,
    List<HealthSubcategoryEntity>? subCategories,
    List<HealthSubcategoryEntity>? medicalServices,
    List<GovernorateEntity>? governorates,
    Banner? banner,
    bool? isLoadingMoreBooking,
    bool? isLoadingMoreMostBooking,
    List<BookingEntity>? currentBookings,
    List<BookingEntity>? historyBookings,
    String? activeBookingType,
    List<MostBookingEntity>? mostBooking,
  }) {
    return HealthState(
      status: status ?? this.status,
      medicalServices: medicalServices ?? this.medicalServices,
      failure: failure ?? this.failure,
      myBookings: myBookings ?? this.myBookings,
      mainCategory: mainCategory ?? this.mainCategory,
      isDoctor: isDoctor ?? this.isDoctor,
      isApproved: isApproved ?? this.isApproved,
      subCategories: subCategories ?? this.subCategories,
      governorates: governorates ?? this.governorates,
      banner: banner ?? this.banner,
      isLoadingMoreBooking: isLoadingMoreBooking ?? this.isLoadingMoreBooking,
      currentBookings: currentBookings ?? this.currentBookings,
      historyBookings: historyBookings ?? this.historyBookings,
      activeBookingType: activeBookingType ?? this.activeBookingType,
      mostBooking: mostBooking ?? this.mostBooking,
      isLoadingMoreMostBooking: isLoadingMoreMostBooking ?? this.isLoadingMoreMostBooking,
    );
  }
}
