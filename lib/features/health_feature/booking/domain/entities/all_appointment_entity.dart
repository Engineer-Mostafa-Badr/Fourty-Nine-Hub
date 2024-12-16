class AllAppointmentEntity {
  final String id;
  final String doctorId;
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String bookingId;
  final String appointmentType;
  final String day;
  final String startTime;
  final String endTime;
  final String dateOfDay;
  String? status;
  final String phone;
  final String additionalNotes;
  final bool isPremium;
  final bool expired;
  final String createdAt;
  final String updatedAt;

  AllAppointmentEntity({required this.id, required this.doctorId, required this.userId, required this.firstName, required this.lastName, required this.gender, required this.bookingId, required this.appointmentType, required this.day, required this.startTime, required this.endTime, required this.dateOfDay, required this.status, required this.phone, required this.additionalNotes, required this.isPremium, required this.expired, required this.createdAt, required this.updatedAt});
}