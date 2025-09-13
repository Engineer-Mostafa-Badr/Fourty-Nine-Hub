class WinnersTenPercentEntity {
  final List<LatestWinnersEntity> latestWinners;
  final num totalWinners;
  final num totalAmount;
  final String currencyEn;
  final String currencyAr;
  final PaginationEntity pagination;

  WinnersTenPercentEntity({
    required this.latestWinners,
    required this.totalWinners,
    required this.totalAmount,
    required this.currencyEn,
    required this.currencyAr,
    required this.pagination,
  });
}

class LatestWinnersEntity {
  final String winnerId;
  final String userId;
  final String firstName;
  final String lastName;
  final String? profilePictureKey;
  final num winAmount;
  final String winAt;

  LatestWinnersEntity({
    required this.winnerId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profilePictureKey,
    required this.winAmount,
    required this.winAt,
  });
}

class PaginationEntity {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationEntity({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}
