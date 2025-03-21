class GiftCompetitionEntity {
  GiftCompetitionEntity({
    required this.withdrawLimit,
    required this.pricePerRequest,
    required this.maxRequests,
    required this.nameEn,
    required this.descriptionEn,
    required this.nameAr,
    required this.descriptionAr,
    required this.id,
    required this.countOfRequest,
    required this.amount,
    required this.descriptionGiftWalletEn,
    required this.descriptionGiftWalletAr,
  });

  final String? id;
  final int? withdrawLimit;
  final num? pricePerRequest;
  final int? maxRequests;
  final String? nameEn;
  final String? descriptionEn;
  final String? nameAr;
  final String? descriptionAr;
  final String? descriptionGiftWalletEn;
  final String? descriptionGiftWalletAr;
  final int? countOfRequest;
  final num? amount;
}

// class CompetitionId {
//   CompetitionId({
//     required this.id,
//     required this.withdrawLimit,
//     required this.pricePerRequest,
//     required this.maxRequests,
//     required this.nameEn,
//     required this.descriptionEn,
//     required this.nameAr,
//     required this.descriptionAr,
//   });
//
//   final String? id;
//   final int? withdrawLimit;
//   final double? pricePerRequest;
//   final int? maxRequests;
//   final String? nameEn;
//   final String? descriptionEn;
//   final String? nameAr;
//   final String? descriptionAr;
//
//   factory CompetitionId.fromJson(Map<String, dynamic> json){
//     return CompetitionId(
//       id: json["_id"],
//       withdrawLimit: json["withdrawLimit"],
//       pricePerRequest: json["pricePerRequest"],
//       maxRequests: json["maxRequests"],
//       nameEn: json["nameEn"],
//       descriptionEn: json["descriptionEn"],
//       nameAr: json["nameAr"],
//       descriptionAr: json["descriptionAr"],
//     );
//   }
//
// }
