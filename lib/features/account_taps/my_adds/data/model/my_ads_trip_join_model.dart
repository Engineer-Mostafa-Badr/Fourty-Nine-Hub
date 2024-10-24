import 'package:fourtyninehub/features/account_taps/my_adds/data/model/docs_trip_join_model.dart';

import '../../domain/entity/my_ads_trip_join_entity.dart';

class MyAdsTripJoinModel extends MyAdsTripJoinEntity {
  MyAdsTripJoinModel(
      {required super.subscribedPremium,
      required super.subscriptionEndDate,
      required super.docs});

  factory MyAdsTripJoinModel.fromJson(Map<String, dynamic> json) {
    return MyAdsTripJoinModel(
      subscribedPremium: json['subscribedPremium'] ?? false,
      subscriptionEndDate: json['subscriptionEndDate'],
      docs: (json['docs'] as List)
          .map((e) => DocsTripJoinModel.fromJson(e))
          .toList(),
    );
  }
}
