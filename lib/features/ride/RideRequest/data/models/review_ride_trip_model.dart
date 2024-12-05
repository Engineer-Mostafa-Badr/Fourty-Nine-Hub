class ReviewRideTripModel {
  final List comments;
  final int driver;
  final int trip;
  final int service;
  final String fullName;
  final int averageRating;
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
