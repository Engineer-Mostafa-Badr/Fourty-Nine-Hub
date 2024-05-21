import 'dart:convert';

class TimesOptionModel {
  final String? time;
  final int? matchTime;
  final num? price;
  TimesOptionModel({
    this.time,
    this.matchTime,
    this.price,
  });

  TimesOptionModel copyWith({
    String? time,
    int? matchTime,
    num? price,
  }) {
    return TimesOptionModel(
      time: time ?? this.time,
      matchTime: matchTime ?? this.matchTime,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'matchTime': matchTime,
      'price': price,
    };
  }

  factory TimesOptionModel.fromMap(Map<String, dynamic> map) {
    return TimesOptionModel(
      time: map['time'],
      matchTime: map['matchTime']?.toInt(),
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TimesOptionModel.fromJson(String source) =>
      TimesOptionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TimesOptionModel(time: $time, matchTime: $matchTime, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimesOptionModel &&
        other.time == time &&
        other.matchTime == matchTime &&
        other.price == price;
  }

  @override
  int get hashCode => time.hashCode ^ matchTime.hashCode ^ price.hashCode;
}
