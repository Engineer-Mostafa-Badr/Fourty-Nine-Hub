import 'package:fourtyninehub/features/payment/domain/entities/fawry_saved_cards_entity.dart';

class SavedCardModel {
  final bool isDefault;
  final String id;
  final String cardToken;
  final String cardAlias;
  final String userId;
  final String brand;
  final int lastFourDigits;
  final int firstSixDigits;
  final int cvv;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedCardModel({
    required this.isDefault,
    required this.id,
    required this.cardToken,
    required this.cardAlias,
    required this.userId,
    required this.brand,
    required this.lastFourDigits,
    required this.firstSixDigits,
    required this.cvv,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    return SavedCardModel(
      isDefault: json['isDefault'] as bool,
      id: json['_id'] as String,
      cardToken: json['cardToken'] as String,
      cardAlias: json['cardAlias'] as String,
      userId: json['userId'] as String,
      brand: json['brand'] as String,
      lastFourDigits: json['lastFourDigits'] as int,
      firstSixDigits: json['firstSixDigits'] as int,
      cvv: json['cvv'] as int,
      isVerified: json['isVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  CardEntity toEntity() {
    return CardEntity(
      isDefault: isDefault,
      id: id,
      cardToken: cardToken,
      cardAlias: cardAlias,
      userId: userId,
      brand: brand,
      lastFourDigits: lastFourDigits,
      firstSixDigits: firstSixDigits,
      cvv: cvv,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
