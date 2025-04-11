import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';

class ReelInstagramDataEntity {
  final List<ReelEntity> reelsData;
  final PaginationEntity paginationEntity;

  ReelInstagramDataEntity({
    required this.reelsData,
    required this.paginationEntity,
  });
}
