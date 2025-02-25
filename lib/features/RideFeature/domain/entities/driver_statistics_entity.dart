class RideDriverStatisticsEntity {
  RideDriverStatisticsEntity({
    required this.deadlineSubscriptionRegular,
    required this.deadlineSubscriptionPremium,
    required this.deadlineId,
    required this.deadlineLicense,
    required this.deadLineDriverLicense,
    required this.tripCount,
    required this.profit,
    required this.totalRating,
    required this.freeRide,
    required this.workingType,
  });
  final int deadlineSubscriptionRegular;
  final int deadlineSubscriptionPremium;
  final int deadlineId;
  final int deadlineLicense;
  final int deadLineDriverLicense;
  final int tripCount;
  final int profit;
  final int totalRating;
  final bool freeRide;
  final String workingType;
}