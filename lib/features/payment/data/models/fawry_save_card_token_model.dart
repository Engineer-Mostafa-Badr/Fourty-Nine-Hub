class FawrySaveCardTokenModel {
  final String cardNumber;
  final String cardExpiryYear;
  final String cardExpiryMonth;
  final String cardAlias;
  final String cvv;

  FawrySaveCardTokenModel({
    required this.cardNumber,
    required this.cardExpiryYear,
    required this.cardExpiryMonth,
    required this.cardAlias,
    required this.cvv,
  });

  factory FawrySaveCardTokenModel.fromJson(Map<String, dynamic> json) {
    return FawrySaveCardTokenModel(
      cardNumber: json['cardNumber'] as String,
      cardExpiryYear: json['cardExpiryYear'] as String,
      cardExpiryMonth: json['cardExpiryMonth'] as String,
      cardAlias: json['cardAlias'] as String,
      cvv: json['cvv'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardExpiryYear': cardExpiryYear,
      'cardExpiryMonth': cardExpiryMonth,
      'cardAlias': cardAlias,
      'cvv': cvv,
    };
  }
}
