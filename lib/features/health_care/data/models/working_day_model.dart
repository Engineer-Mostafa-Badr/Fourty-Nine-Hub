import '../../domain/entities/working_days_entity.dart';

class WorkingDayModel extends WorkingDaysEntity {
  WorkingDayModel(
      {required super.label,
      required super.date,
      required super.available,
      required super.startHour,
      required super.endHour});
}
