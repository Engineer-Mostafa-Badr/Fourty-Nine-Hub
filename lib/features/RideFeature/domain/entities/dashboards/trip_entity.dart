import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/rating_entity.dart';
import 'client_details_entity.dart';
import 'driver_details_entity.dart';
import 'sub_category_entity.dart';
import 'trip_details_entity.dart';

class TripEntity extends Equatable {
  final ClientDetailsEntity? clientDetails;
  final ClientDetailsEntity? driverDetails;
  final SubCategoryEntity? subCategory;
  final TripDetailsEntity? tripDetails;
  final StateEntity? state;
  final TripRatingEntity? rating;
  String? modeType;

   TripEntity({this.modeType='',  
    required this.clientDetails,
    required this.driverDetails,
    required this.subCategory,
    required this.tripDetails,required this.state,required this.rating,
  });

  @override
  List<Object?> get props =>
      [clientDetails, driverDetails, subCategory, tripDetails,state,rating];
}

// state.dart
class StateEntity {
  final bool isButtonEnabled;

  StateEntity({required this.isButtonEnabled});

}

// trip_rating.dart
class TripRatingEntity {
  final RatingEntity yourRating;
  final RatingEntity client;

  TripRatingEntity({required this.yourRating, required this.client});


}