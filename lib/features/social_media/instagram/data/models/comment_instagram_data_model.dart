import '../../../../account_taps/wallet/data/models/pagination_model.dart';
import 'comment_instagram_model.dart';
import '../../domain/entities/comment_instagram_data_entiry.dart';

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
