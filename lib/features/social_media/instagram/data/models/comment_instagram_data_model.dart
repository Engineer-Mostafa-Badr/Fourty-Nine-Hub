import 'package:fourtyninehub/features/account_taps/wallet/data/models/pagination_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';

class CommentInstagramDataModel extends CommentInstagramDataEntiry {
  CommentInstagramDataModel({
    required super.comments,
    required super.pagination,
  });

  factory CommentInstagramDataModel.fromJson(Map<String, dynamic> json) {
    return CommentInstagramDataModel(
      comments: (json['comments'] as List)
          .map((e) => CommentInstagramModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
