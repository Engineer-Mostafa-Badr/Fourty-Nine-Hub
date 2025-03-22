import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';

import 'client_details_model.dart';
import 'driver_details_model.dart';
import 'sub_category_model.dart';
import 'trip_details_model.dart';

class TripModel extends TripEntity {
  const TripModel({
    required ClientDetailsModel? clientDetails,
    required DriverDetailsModel? driverDetails,
    required SubCategoryModel? subCategory,
    required TripDetailsModel? tripDetails,
    required StateModel? state,
    required TripRatingModel? rating,
  }) : super(
          clientDetails: clientDetails,
          driverDetails: driverDetails,
          subCategory: subCategory,
          tripDetails: tripDetails,
          state: state,
          rating: rating,
        );

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      clientDetails: ClientDetailsModel.fromJson(json['clientDetails']),
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
      subCategory: SubCategoryModel.fromJson(json['subCategory']),
      tripDetails: TripDetailsModel.fromJson(json['tripDetails']),
      state: json['state'] != null ? StateModel.fromJson(json['state']) : null,
      rating: json['rating'] != null
          ? TripRatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class StateModel extends StateEntity {
  StateModel({required super.isButtonEnabled});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      isButtonEnabled: json['isButtonEnabled'],
    );
  }
}

class TripRatingModel extends TripRatingEntity {
  TripRatingModel(
      {required RatingModel yourRating, required RatingModel client})
      : super(yourRating: yourRating, client: client);

  factory TripRatingModel.fromJson(Map<String, dynamic> json) {
    return TripRatingModel(
      yourRating: RatingModel.fromJson(json['yourRating']),
      client: RatingModel.fromJson(json['client']),
    );
  }
}
