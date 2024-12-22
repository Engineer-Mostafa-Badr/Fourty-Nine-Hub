import 'package:fourtyninehub/res/strings/labels.dart';

class AppointmentEntity {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final String appointmentType;
  final String dateOfDay;
  final bool isExpired;
  final AppointmentStatus status;

  AppointmentEntity(
      {required this.id,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.appointmentType,
      required this.dateOfDay,
      required this.isExpired,
      required this.status});

  bool get isAvailable => status == AppointmentStatus.pending;
}

enum AppointmentStatus { pending, completed }

extension AppointmentStatusExtension on AppointmentStatus {
  String get translatedName {
    switch (this) {
      case AppointmentStatus.pending:
        return Labels.pending;
      case AppointmentStatus.completed:
        return Labels.completed;
    }
  }
}

extension AppointmentStatusExtensionString on String {
  AppointmentStatus get toAppointmentStatus {
    switch (toLowerCase()) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'completed':
        return AppointmentStatus.completed;
      default:
        return AppointmentStatus.pending;
    }
  }
}
