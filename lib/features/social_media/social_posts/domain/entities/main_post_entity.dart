import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';

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
  Duration get publishedDuration => TimeUtils.calculateDuration(createdAt);

  String get sinceTime => TimeUtils.getSinceTime(createdAt);

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
