import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/publisher_entity.dart';

class BiddingEntity {
  final int id;
  final PublisherEntity user;
  final num bidding;
  final DateTime createdAt;
  Duration get publishedSinceDuration=> createdAt.difference(DateTime.now());
 String get formatedSinceTime => DurationHelper().sinceTime(duration: publishedSinceDuration);
  BiddingEntity({
    required this.id, 
    required this.user, 
    required this.bidding, 
    required this.createdAt
  });
}
