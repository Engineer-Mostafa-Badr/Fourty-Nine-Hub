import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';

import 'trip_info.dart';

class TripJoinRequestModel extends TripJoinCardEntity {
  String? firstName;
  @override
  String? gender;
  TripInfo? tripInfo;
  String? allowStatus;
  @override
  String? brand;
  @override
  String? model;
  String? paymentMethods;

  TripJoinRequestModel({
    this.firstName,
    this.gender,
    this.tripInfo,
    this.allowStatus,
    this.brand,
    this.model,
    this.paymentMethods,
  }) : super(
          id: tripInfo?.id,
          userId: tripInfo?.userId,
          requestOwnerFirstName: firstName,
          categoryId: tripInfo?.categoryId,
          brand: brand,
          model: model,
          journeyPrice: tripInfo?.price,
          status: tripInfo?.status,
          seatNumber: tripInfo?.passengers,
          isRepeated: tripInfo?.isRepeat,
          startingAddressAr: tripInfo?.fromAr,
          destinationAddressAr: tripInfo?.toAr,
          startingAddressEn: tripInfo?.fromEn,
          destinationAddressEn: tripInfo?.toEn,
          isApproved: allowStatus == 'enable',
          publishDate: tripInfo?.time,
          phone: tripInfo?.phone,
          gender: gender,
          paymentMethod: paymentMethods,
        );

  @override
  String toString() {
    return 'TripJoinRequestModel(firstName: $firstName, gender: $gender, tripInfo: $tripInfo, allowStatus: $allowStatus , brand: $brand ,  model: $model , paymentMethods: $paymentMethods)';
  }

  factory TripJoinRequestModel.fromJson(Map<String, dynamic> json) {
    return TripJoinRequestModel(
      firstName: json['firstName'] as String?,
      gender: json['gender'] as String?,
      tripInfo: json['tripInfo'] == null ? null : TripInfo.fromJson(json['tripInfo'] as Map<String, dynamic>),
      allowStatus: json['allowStatus'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      paymentMethods: json['paymentMethods'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'gender': gender,
        'tripInfo': tripInfo?.toJson(),
        'allowStatus': allowStatus,
      };
}
