import '../../domain/entity/sub_tab_entity.dart';

class SubTabModel extends SubTabEntity {
  SubTabModel(
      {required super.id,
      required super.userId,
      required super.auction,
      required super.carpool,
      required super.chance,
      required super.installment,
      required super.tripJoin});

  factory SubTabModel.fromJson(Map<String, dynamic> json) {
    return SubTabModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      auction: json['Auction'] ?? false,
      carpool: json['Carpool'] ?? false,
      chance: json['Chance'] ?? false,
      installment: json['Installment'] ?? false,
      tripJoin: json['TripJoin'] ?? false,
    );
  }
}
