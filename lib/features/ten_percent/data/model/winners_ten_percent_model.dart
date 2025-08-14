import '../../domain/entities/winners_ten_percent_entity.dart';

class WinnersTenPercentModel extends WinnersTenPercentEntity {
  WinnersTenPercentModel({
    required super.latestWinners,
    required super.totalWinners,
    required super.totalAmount,
    required super.currencyEn,
    required super.currencyAr,
    required super.pagination,
  });

  factory WinnersTenPercentModel.fromJson(Map<String, dynamic> json) {
    return WinnersTenPercentModel(
      latestWinners: (json['latestWinners'] as List)
          .map((e) => LatestWinnersModel.fromJson(e))
          .toList(),
      totalWinners: json['totalWinners'],
      totalAmount: json['totalAmount'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}

class LatestWinnersModel extends LatestWinnersEntity {
  LatestWinnersModel({
    required super.winnerId,
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.profilePictureKey,
    required super.winAmount,
    required super.winAt,
  });

  factory LatestWinnersModel.fromJson(Map<String, dynamic> json) {
    return LatestWinnersModel(
      winnerId: json['winnerId'],
      userId: json['winnerData']['userId'],
      firstName: json['winnerData']['firstName'],
      lastName: json['winnerData']['lastName'],
      profilePictureKey: json['winnerData']['profilePictureKey'],
      winAmount: json['winAmount'],
      winAt: json['winAt'],
    );
  }
}

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.page,
    required super.limit,
    required super.totalItems,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'],
      limit: json['limit'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
    );
  }
}
