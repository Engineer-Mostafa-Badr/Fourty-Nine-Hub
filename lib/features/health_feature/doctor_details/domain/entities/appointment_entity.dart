import 'package:fourtyninehub/res/strings/labels.dart';

class AppointmentEntity {
  final String id;
  final String day;
  final String time;
  final AppointmentStatus status;

  AppointmentEntity(
      {required this.id,
      required this.day,
      required this.time,
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
