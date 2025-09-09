import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/story_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_basic_entity.dart';

class UserWithStoriesEntity extends Equatable {
  final UserBasicEntity user;
  final List<StoryBasicEntity> stories;
  final int storyCount;

  const UserWithStoriesEntity({
    required this.user,
    required this.stories,
    required this.storyCount,
  });

  @override
  List<Object?> get props => [user, stories, storyCount];
}
