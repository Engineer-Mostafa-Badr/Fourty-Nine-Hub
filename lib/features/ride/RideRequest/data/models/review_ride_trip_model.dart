class ReviewRideTripModel {
  final List comments;
  final double driver;
  final double trip;
  final double service;
  final String fullName;
  final double averageRating;
  final int numberOfReviewers;
  ReviewRideTripModel(
      {required this.comments,
      required this.driver,
      required this.trip,
      required this.averageRating,
      required this.numberOfReviewers,
      required this.service,
      required this.fullName});
}
