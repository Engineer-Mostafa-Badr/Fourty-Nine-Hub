import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/pagination_details_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_with_stories_entity.dart';

class FriendsStoriesEntity extends Equatable {
  final List<UserWithStoriesEntity> stories;
  final PaginationDetailsEntity paginationDetails;

  const FriendsStoriesEntity({
    required this.stories,
    required this.paginationDetails,
  });

  @override
  List<Object?> get props => [stories, paginationDetails];
}