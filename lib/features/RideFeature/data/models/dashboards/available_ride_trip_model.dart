import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';

class AvailableRideTripModel extends AvailableRideTripEntity {
  AvailableRideTripModel({
    required super.id,
    required super.isAutoAccept,
    required super.isPremium,
    required super.price,
    required super.paymentMethod,
    required super.passengers,
    required super.fromAddress,
    required super.toAddress,
    required super.distance,
    required super.duration,
    required super.subcategoryId,
    required super.subcategoryImage,
    required super.subcategoryNameEn,
    required super.subcategoryNameAr,
    required super.clientId,
    required super.clientImage,
    required super.clientName,
    required super.clientGender,
    required super.clientRatingCount,
    required super.clientRatingAverage,
    required super.createdAt,
    required super.isButtonEnabled,
  });

  //fromJson
  factory AvailableRideTripModel.fromJson(Map<String, dynamic> json) {
    return AvailableRideTripModel(
      id: json['tripeDetails']['id']??'',
      isAutoAccept: json['tripeDetails']['isAutoAccept']??false,
      isPremium: json['tripeDetails']['isPremium']??false,
      price: json['tripeDetails']['price']??0,
      paymentMethod: json['tripeDetails']['paymentMethod']??'',
      passengers: json['tripeDetails']['passengers']??0,
      fromAddress: json['tripeDetails']['location']['start']['startAddressTitle']??'',
      toAddress: json['tripeDetails']['location']['target']['targetAddressTitle']??'',
      distance: json['tripeDetails']['location']['distance']??0,
      duration: json['tripeDetails']['location']['duration']??0,
      subcategoryId: json['tripeDetails']['subcategory']['id']??'',
      subcategoryImage: json['tripeDetails']['subcategory']['nameEn']??'',
      subcategoryNameEn: json['tripeDetails']['subcategory']['nameAr']??'',
      subcategoryNameAr: json['tripeDetails']['subcategory']['picture']??'',
      clientId: json['clientDetails']['id']??'',
      clientImage: json['clientDetails']['profilePicture']??'',
      clientName: json['clientDetails']['firstName']??'',
      clientGender: json['clientDetails']['id']??'',
      clientRatingCount: json['clientDetails']['rating']['ratingCount']??0,
      clientRatingAverage: json['clientDetails']['rating']['average']??0,
      createdAt: json['createdAt'],
      isButtonEnabled: json['state']['isButtonEnabled']??false,
    );
  }
}
