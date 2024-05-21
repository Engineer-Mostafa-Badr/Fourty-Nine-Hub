import '../../../../core/utils/date_helper.dart';

class WorkingDaysEntity {
  final String label;
  final DateTime date;
  final bool available;
  final int startHour;
  final int endHour;
  String get formattedDate => DateHelper().getDate(date: date);
  WorkingDaysEntity({
    required this.label,
    required this.date,
    required this.available,
    required this.startHour, 
    required this.endHour
  });
}
