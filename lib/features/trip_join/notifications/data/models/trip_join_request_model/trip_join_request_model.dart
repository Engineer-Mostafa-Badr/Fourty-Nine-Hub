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
  @override
  bool? subscribedPremium;

  TripJoinRequestModel({
    this.firstName,
    this.gender,
    this.tripInfo,
    this.allowStatus,
    this.brand,
    this.model,
    this.paymentMethods,
    this.subscribedPremium,
  }) : super(
          id: tripInfo?.id,
          userId: tripInfo?.userId,
          requestOwnerFirstName: firstName,
          categoryId: tripInfo?.categoryId,
          brand: brand,
          model: model,
          journeyPrice: tripInfo?.price,
          status: tripInfo?.status,
          seatNumber: tripInfo?.passengers?.toInt(),
          isRepeated: tripInfo?.isRepeat,
          startingAddressAr: tripInfo?.fromAr,
          destinationAddressAr: tripInfo?.toAr,
          startingAddressEn: tripInfo?.fromEn,
          destinationAddressEn: tripInfo?.toEn,
          isApproved: allowStatus == 'enable',
          publishDate: tripInfo?.time?.toInt(),
          phone: tripInfo?.phone,
          gender: gender,
          paymentMethod: paymentMethods,
          subscribedPremium: subscribedPremium,
        );

  @override
  String toString() {
    return 'TripJoinRequestModel(firstName: $firstName, gender: $gender, tripInfo: $tripInfo, allowStatus: $allowStatus , brand: $brand ,  model: $model , paymentMethods: $paymentMethods , subscribedPremium: $subscribedPremium)';
  }

  factory TripJoinRequestModel.fromJson(Map<String, dynamic> json) {
    return TripJoinRequestModel(
      firstName: json['firstName'] as String?,
      gender: json['gender'] as String?,
      tripInfo: json['tripInfo'] == null
          ? null
          : TripInfo.fromJson(json['tripInfo'] as Map<String, dynamic>),
      allowStatus: json['allowStatus'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      paymentMethods: json['paymentMethods'] as String?,
      subscribedPremium: json['subscribedPremium'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'gender': gender,
        'tripInfo': tripInfo?.toJson(),
        'allowStatus': allowStatus,
      };
}
