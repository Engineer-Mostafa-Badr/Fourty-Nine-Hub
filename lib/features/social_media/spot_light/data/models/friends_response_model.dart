import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/friends_stories_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/pagination_details_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/story_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_with_stories_entity.dart';

class FriendsStoriesModel extends FriendsStoriesEntity {
  const FriendsStoriesModel({
    required super.stories,
    required super.paginationDetails,
  });

  factory FriendsStoriesModel.fromJson(Map<String, dynamic> json) {
    return FriendsStoriesModel(
      stories: (json['stories'] as List<dynamic>?)
              ?.map((e) =>
                  UserWithStoriesModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      paginationDetails: PaginationDetailsModel.fromJson(
          json['paginationDetails'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stories':
          stories.map((e) => (e as UserWithStoriesModel).toJson()).toList(),
      'paginationDetails':
          (paginationDetails as PaginationDetailsModel).toJson(),
    };
  }
}

class UserWithStoriesModel extends UserWithStoriesEntity {
  const UserWithStoriesModel({
    required super.user,
    required super.stories,
    required super.storyCount,
  });

  factory UserWithStoriesModel.fromJson(Map<String, dynamic> json) {
    return UserWithStoriesModel(
      user: UserBasicModel.fromJson(json['user'] as Map<String, dynamic>),
      stories: (json['stories'] as List<dynamic>?)
              ?.map((e) => StoryBasicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      storyCount: json['storyCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserBasicModel).toJson(),
      'stories': stories.map((e) => (e as StoryBasicModel).toJson()).toList(),
      'storyCount': storyCount,
    };
  }
}

class UserBasicModel extends UserBasicEntity {
  const UserBasicModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.username,
    super.userProfileUrl,
  });

  factory UserBasicModel.fromJson(Map<String, dynamic> json) {
    return UserBasicModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      userProfileUrl: json['userProfileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'userProfileUrl': userProfileUrl,
    };
  }
}

class StoryBasicModel extends StoryBasicEntity {
  const StoryBasicModel({
    required super.id,
    required super.isViewed,
    super.type,
    super.content,
    super.thumbnailUrl,
    super.createdAt,
    super.color,
    super.fontFamily,
  });

  factory StoryBasicModel.fromJson(Map<String, dynamic> json) {
    return StoryBasicModel(
      id: json['id'] ?? json['_id'] ?? '',
      isViewed: json['isViewed'] ?? false,
      type: json['type'],
      content: json['content'],
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnailSignedUrl'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      color: json['color'],
      fontFamily: json['fontFamily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isViewed': isViewed,
      'type': type,
      'content': content,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt?.toIso8601String(),
      'color': color,
      'fontFamily': fontFamily,
    };
  }
}

class PaginationDetailsModel extends PaginationDetailsEntity {
  const PaginationDetailsModel({
    required super.page,
    required super.limit,
    required super.totalItems,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPrevPage,
    super.nextPage,
    super.prevPage,
  });

  factory PaginationDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaginationDetailsModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
      'nextPage': nextPage,
      'prevPage': prevPage,
    };
  }
}
