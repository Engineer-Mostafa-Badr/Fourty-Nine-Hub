import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/publisher_entity.dart';

class UsersListEntity {
  final int id;
  final PublisherEntity user;
  UsersListEntity({
    required this.id, 
    required this.user,
  });
}
