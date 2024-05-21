import 'dart:convert';

class AddToCartModel {
  final int? eventId;
  final String? selectDate;
  final String? selectTime;
  final int? tickets;
  final int? cartId;
  AddToCartModel({
    this.eventId,
    this.selectDate,
    this.selectTime,
    this.tickets,
    this.cartId,
  });

  AddToCartModel copyWith({
    int? eventId,
    String? selectDate,
    String? selectTime,
    int? tickets,
    int? cartId,
  }) {
    return AddToCartModel(
      eventId: eventId ?? this.eventId,
      selectDate: selectDate ?? this.selectDate,
      selectTime: selectTime ?? this.selectTime,
      tickets: tickets ?? this.tickets,
      cartId: cartId ?? this.cartId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'EventId': eventId,
      'SelectDate': selectDate,
      'SelectTime': selectTime,
      'Tickets': tickets,
      'CartId': cartId,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      eventId: map['eventId']?.toInt(),
      selectDate: map['selectDate'],
      selectTime: map['selectTime'],
      tickets: map['tickets']?.toInt(),
      cartId: map['cartId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddToCartModel.fromJson(String source) =>
      AddToCartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddToCartModel(eventId: $eventId, selectDate: $selectDate, selectTime: $selectTime, tickets: $tickets, cartId: $cartId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddToCartModel &&
        other.eventId == eventId &&
        other.selectDate == selectDate &&
        other.selectTime == selectTime &&
        other.tickets == tickets &&
        other.cartId == cartId;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        selectDate.hashCode ^
        selectTime.hashCode ^
        tickets.hashCode ^
        cartId.hashCode;
  }
}
