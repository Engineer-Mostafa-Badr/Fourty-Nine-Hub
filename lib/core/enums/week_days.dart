enum WeekDays { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

extension WeekDaysExtensionOnString on String {
  WeekDays get toWeekDay {
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

extension WeekDaysExtensionOnInt on int {
  WeekDays get toWeekDay {
    switch (this) {
      case 7:
        return WeekDays.sunday;
      case 1:
        return WeekDays.monday;
      case 2:
        return WeekDays.tuesday;
      case 3:
        return WeekDays.wednesday;
      case 4:
        return WeekDays.thursday;
      case 5:
        return WeekDays.friday;
      case 6:
        return WeekDays.saturday;
      default:
        return WeekDays.sunday;
    }
  }
}
