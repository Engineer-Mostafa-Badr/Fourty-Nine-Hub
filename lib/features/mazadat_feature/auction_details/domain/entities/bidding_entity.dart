import 'package:fourtyninehub/core/utils/duration_helper.dart';


import '../../../../authentication/domain/entities/user_entity.dart';

class BiddingEntity {
  final String id;
  final UserEntity user;
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
