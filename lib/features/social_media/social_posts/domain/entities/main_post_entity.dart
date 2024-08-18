import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import '../../../../../core/utils/duration_helper.dart';

class MainPostEntity {
  final String id;
  String? content;
  String? type;
  List<String>? images;
  final bool isShared;
  bool? isDocumentation;
  final dynamic user;
  FeelingEntity? feeling;
  ActivityEntity? activity;
  String? backgroundColor;

  DateTime? createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);

  MainPostEntity({
    required this.id,
    this.content,
    required this.type,
    this.images,
    required this.user,
    this.isShared = false,
    this.isDocumentation = false,
    this.createdAt,
    this.feeling,
    this.activity,
    this.backgroundColor,
  });
}
