import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/publisher_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../requests_history/domain/entities/address_entity.dart';
import 'detail_entity.dart';

class AdEntity {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final num price;
  final bool active;
  final AdStatisticsEntity? statistics;
  final AddressEntity? address;
  final UserEntity? user;
  List<DetailEntiy> details;
  DateTime createdAt;
  final String phone;
  final String? subCategoryId;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);
  Duration get restTimeDuration => DateTime.now().difference(createdAt);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);

  AdEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.price,
      required this.address,
      required this.phone,
      this.statistics,
      required this.user,
      this.subCategoryId,
      required this.active,
      required this.details,
      required this.createdAt});
}
