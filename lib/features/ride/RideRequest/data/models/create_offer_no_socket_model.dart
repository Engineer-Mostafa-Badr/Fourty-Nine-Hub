class CreateOfferNoSocketModel {
  double? price;
  String? subcategoryId;
  bool? isPremium;

  CreateOfferNoSocketModel({
    this.price,
    this.subcategoryId,
    this.isPremium,
  });

  factory CreateOfferNoSocketModel.fromJson(Map<String, dynamic> json) {
    return CreateOfferNoSocketModel(
      price: json['price'] as double?,
      subcategoryId: json['subcategoryId'] as String?,
      isPremium: json['isPremium'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'subcategoryId': subcategoryId,
        'isPremium': false,
      };
}
