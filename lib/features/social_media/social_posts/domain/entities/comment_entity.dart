import '../../../../../core/utils/duration_helper.dart';

class CommentEntity {
  final String id;
  final String content;
  final String post;
  dynamic user;
  bool? isLove;
  bool? isLikes;
  bool? isWow;
  bool? isSad;
  bool? isAngry;
  bool? isHaha;
  num? likesCount;
  num? loveCount;
  num? wowCount;
  num? sadCount;
  num? angryCount;
  num? hahaCount;
  num? repliesCount;
  num? totalCount;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  CommentEntity({
    required this.id,
    required this.content,
    required this.post,
    required this.createdAt,
    required this.user,
    this.likesCount = 0,
    this.loveCount = 0,
    this.wowCount = 0,
    this.sadCount = 0,
    this.angryCount = 0,
    this.hahaCount = 0,
    this.repliesCount = 0,
    this.totalCount = 0,
    this.isLove = false,
    this.isLikes = false,
    this.isWow = false,
    this.isSad = false,
    this.isAngry = false,
    this.isHaha = false,
  });
}
