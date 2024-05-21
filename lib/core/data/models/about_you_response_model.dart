import 'dart:convert';

class AboutYouResponseModel {
  final Data? data;
  final PaymentMethodModel? paymentMethods;
  AboutYouResponseModel({
    this.data,
    this.paymentMethods,
  });

  AboutYouResponseModel copyWith({
    Data? data,
    PaymentMethodModel? paymentMethods,
  }) {
    return AboutYouResponseModel(
      data: data ?? this.data,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
      'paymentMethods': paymentMethods?.toMap(),
    };
  }

  factory AboutYouResponseModel.fromMap(Map<String, dynamic> map) {
    return AboutYouResponseModel(
      data: map['data'] != null ? Data.fromMap(map['data']) : null,
      paymentMethods: map['paymentMethods'] != null
          ? PaymentMethodModel.fromMap(map['paymentMethods'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutYouResponseModel.fromJson(String source) =>
      AboutYouResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AboutYouResponseModel(data: $data, paymentMethods: $paymentMethods)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AboutYouResponseModel &&
        other.data == data &&
        other.paymentMethods == paymentMethods;
  }

  @override
  int get hashCode => data.hashCode ^ paymentMethods.hashCode;
}

class Data {
  final String? accessToken;
  final String? refreshToken;
  final String? id;
  Data({
    this.accessToken,
    this.refreshToken,
    this.id,
  });

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    String? id,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'id': id,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() =>
      'Data(accessToken: $accessToken, refreshToken: $refreshToken, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.id == id;
  }

  @override
  int get hashCode =>
      accessToken.hashCode ^ refreshToken.hashCode ^ id.hashCode;
}

class PaymentMethodModel {
  final int? eventId;
  final num? price;
  final bool? enableCreditCard;
  final bool? enableKNET;
  PaymentMethodModel({
    this.eventId,
    this.price,
    this.enableCreditCard,
    this.enableKNET,
  });

  PaymentMethodModel copyWith({
    int? eventId,
    num? price,
    bool? enableCreditCard,
    bool? enableKNET,
  }) {
    return PaymentMethodModel(
      eventId: eventId ?? this.eventId,
      price: price ?? this.price,
      enableCreditCard: enableCreditCard ?? this.enableCreditCard,
      enableKNET: enableKNET ?? this.enableKNET,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'price': price,
      'enableCreditCard': enableCreditCard,
      'enableKNET': enableKNET,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      eventId: map['eventId']?.toInt(),
      price: map['price'],
      enableCreditCard: map['enableCreditCard'],
      enableKNET: map['enableKNET'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethodModel.fromJson(String source) =>
      PaymentMethodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentMethodModel(eventId: $eventId, price: $price, enableCreditCard: $enableCreditCard, enableKNET: $enableKNET)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMethodModel &&
        other.eventId == eventId &&
        other.price == price &&
        other.enableCreditCard == enableCreditCard &&
        other.enableKNET == enableKNET;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        price.hashCode ^
        enableCreditCard.hashCode ^
        enableKNET.hashCode;
  }
}
