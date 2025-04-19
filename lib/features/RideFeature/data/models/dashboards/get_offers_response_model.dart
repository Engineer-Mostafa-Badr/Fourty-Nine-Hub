import '../../../domain/entities/get_offers_entity.dart';
import 'pagination_model.dart';
import 'trip_model.dart';

class GetOffersResponseModel extends GetOffersResponseEntity {
  
  GetOffersResponseModel({required super.status, required GetOffersDataModel super.data});

   factory GetOffersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetOffersResponseModel(
      status: json['status'],
      data: GetOffersDataModel.fromJson(json['data']),
    );
  }
}

class GetOffersDataModel extends GetOffersDataEntity {
  GetOffersDataModel({required List<TripModel> trips, required PaginationModel pagination})
      : super(offers: trips, pagination: pagination);

  factory GetOffersDataModel.fromJson(Map<String, dynamic> json) {
    return GetOffersDataModel(
      trips: List<TripModel>.from(json['offers'].map((x) => TripModel.fromJson(x))),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
