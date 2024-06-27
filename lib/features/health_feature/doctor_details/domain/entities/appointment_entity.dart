class AppointmentEntity {
  final int id;
    final String date;
    final String fromTime;
    final String toTime;
    final bool available;

  AppointmentEntity(
      {required this.id, required this.date, required this.fromTime, required this.toTime, required this.available});
}
