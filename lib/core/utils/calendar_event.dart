

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

//  bool isSameDay = false;
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// );

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
