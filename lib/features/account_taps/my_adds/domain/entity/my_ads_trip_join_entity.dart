import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/docs_trip_join_entity.dart';

class MyAdsTripJoinEntity {
  final bool subscribedPremium;
  final dynamic subscriptionEndDate;
  final List<DocsTripJoinEntity> docs;

  MyAdsTripJoinEntity(
      {required this.subscribedPremium,
      required this.subscriptionEndDate,
      required this.docs});
}
