class DoctorStatisticsEntity {
  final DoctorStatisticsForBookingTypeEntity clinic;
  final DoctorStatisticsForBookingTypeEntity homeVisit;
  final DoctorStatisticsForBookingTypeEntity call;

  const DoctorStatisticsEntity({
    required this.clinic,
    required this.homeVisit,
    required this.call,
  });

  num get totalEarned =>
      clinic.totalEarned + homeVisit.totalEarned + call.totalEarned;

  num get appointmentsCount =>
      clinic.appointmentsCount +
      homeVisit.appointmentsCount +
      call.appointmentsCount;
}

class DoctorStatisticsForBookingTypeEntity {
  final num appointmentsCount;
  final num totalEarned;

  DoctorStatisticsForBookingTypeEntity(
      {required this.appointmentsCount, required this.totalEarned});
}
