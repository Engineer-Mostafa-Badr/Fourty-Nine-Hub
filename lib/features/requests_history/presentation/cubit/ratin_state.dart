import 'package:fourtyninehub/core/error/failure.dart';

class RatingState {}

class InitalRatingState extends RatingState {}

class SuccessRatingTripState extends RatingState {}

class FailiureRatingState extends RatingState {
  final Failure failure;

  FailiureRatingState({required this.failure});
}
