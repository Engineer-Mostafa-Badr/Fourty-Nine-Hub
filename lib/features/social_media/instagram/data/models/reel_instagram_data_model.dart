import 'package:fourtyninehub/features/account_taps/wallet/data/models/pagination_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/reel_model.dart';

class ReelInstagramDataModel extends ReelInstagramDataEntity {
  ReelInstagramDataModel({
    required super.reelsData,
    required super.paginationEntity,
  });

  factory ReelInstagramDataModel.fromJson(Map<String, dynamic> json) {
    return ReelInstagramDataModel(
      reelsData:
          (json['reels'] as List).map((e) => ReelModel.fromJson(e)).toList(),
      paginationEntity: PaginationModel.fromJson(json['paginationDetails']),
    );
  }
}
