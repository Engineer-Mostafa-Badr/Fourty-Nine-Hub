import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';

import 'trip.dart';

class PickMeCardModel extends PickMeCardEntity {
  Trip? trip;
  String? allowStatus;
  String? paymentMethods;

  PickMeCardModel({this.trip, this.allowStatus, this.paymentMethods})
      : super(
          id: trip?.id,
          userId: trip?.userId?.id,
          firstName: trip?.userId?.firstName,
          categoryId: trip?.categoryId?.id,
          journeyPrice: trip?.price,
          //! status: ,
          isRepeated: trip?.isRepeat,
          startingAddressAr: trip?.fromAr,
          destinationAddressAr: trip?.toAr,
          startingAddressEn: trip?.fromEn,
          destinationAddressEn: trip?.toEn,
          isApproved: allowStatus == 'enable',
          publishDate: trip?.time?.toInt(),
          phone: trip?.phone,
          gender: trip?.userId?.gender,
          paymentMethod: paymentMethods,
          //! subscribedPremium: index.isEven,
        );

  @override
  String toString() {
    return 'PickMeCardModel(trip: $trip, allowStatus: $allowStatus, paymentMethods: $paymentMethods)';
  }

  factory PickMeCardModel.fromJson(Map<String, dynamic> json) {
    return PickMeCardModel(
      trip: json['trip'] == null
          ? null
          : Trip.fromJson(json['trip'] as Map<String, dynamic>),
      allowStatus: json['allowStatus'] as String?,
      paymentMethods: json['paymentMethods'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'trip': trip?.toJson(),
        'allowStatus': allowStatus,
        'paymentMethods': paymentMethods,
      };
}
