class DriverStatisticsEntity {
  final int allTripsCount;
  final int todaysTripsCount;
  final double todaysIncome;
  final int reviewsCount;
  final double ratingAvg;

  DriverStatisticsEntity(
      {required this.allTripsCount,
      required this.todaysTripsCount,
      required this.todaysIncome,
      required this.reviewsCount,
      required this.ratingAvg});
}
