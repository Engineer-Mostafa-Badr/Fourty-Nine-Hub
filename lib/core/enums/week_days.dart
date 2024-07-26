enum WeekDays { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

extension WeekDaysExtensionOnString on String {
  WeekDays get weekDay {
    switch (this) {
      case 'sunday':
        return WeekDays.sunday;
      case 'monday':
        return WeekDays.monday;
      case 'tuesday':
        return WeekDays.tuesday;
      case 'wednesday':
        return WeekDays.wednesday;
      case 'thursday':
        return WeekDays.thursday;
      case 'friday':
        return WeekDays.friday;
      case 'saturday':
        return WeekDays.saturday;

      default:
        return WeekDays.sunday;
    }
  }
}
