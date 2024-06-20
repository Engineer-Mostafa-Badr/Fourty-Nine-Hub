import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/publisher_entity.dart';
import 'package:intl/intl.dart';

import '../../../../requests_history/domain/entities/address_entity.dart';
import 'detail_entity.dart';

class AdEntity {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final int price;
  final bool active;
  final AdStatisticsEntity? statistics;
  final AddressEntity address;
  final PublisherEntity user;
  List<DetailEntiy> details;
  DateTime createdAt;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);

  AdEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.price,
      required this.address,
      this.statistics, 
      required this.user,
      required this.active,
      required this.details,
      required this.createdAt});
}
