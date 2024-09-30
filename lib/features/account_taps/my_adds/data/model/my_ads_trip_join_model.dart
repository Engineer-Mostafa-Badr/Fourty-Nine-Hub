import 'package:fourtyninehub/features/account_taps/my_adds/data/model/docs_trip_join_model.dart';

import '../../domain/entity/my_ads_trip_join_entity.dart';

class MyAdsTripJoinModel extends MyAdsTripJoinEntity {
  MyAdsTripJoinModel(
      {required super.subscribedPremium,
      required super.subscriptionEndDate,
      required super.docs});

  factory MyAdsTripJoinModel.fromJson(Map<String, dynamic> json) {
    return MyAdsTripJoinModel(
      subscribedPremium: json['subscribedPremium'] as bool,
      subscriptionEndDate: json['subscriptionEndDate'] as String,
      docs: (json['docs'] as List<dynamic>)
          .map((doc) => DocsTripJoinModel.fromJson(doc as Map<String, dynamic>))
          .toList(),
    );
  }
}
