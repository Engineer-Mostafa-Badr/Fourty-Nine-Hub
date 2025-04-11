import 'package:fourtyninehub/features/account_taps/wallet/data/models/pagination_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_data_entity.dart';

class InstagramPostDataModel extends InstagramPostDataEntity {
  InstagramPostDataModel({
    required super.posts,
    required super.pagination,
  });

  factory InstagramPostDataModel.fromJson(Map<String, dynamic> json) {
    return InstagramPostDataModel(
      posts: (json['posts'] as List)
          .map((e) => InstagramPostModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
