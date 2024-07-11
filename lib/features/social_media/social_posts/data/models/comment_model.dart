import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel(
      {required super.id,
      required super.content,
      required super.post,
      required super.createdAt,
      super.angryCount,
      super.likesCount,
      super.loveCount,
      super.repliesCount,
      super.sadCount,
      super.wowCount});
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      content: json['content'],
      post: json['post'],
      likesCount: json['likesCount'],
      loveCount: json['loveCount'],
      wowCount: json['wowCount'],
      sadCount: json['sadCount'],
      angryCount: json['angryCount'],
      repliesCount: json['repliesCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
