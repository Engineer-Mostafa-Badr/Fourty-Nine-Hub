import 'package:equatable/equatable.dart';

// Entity classes
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

class UserBasicEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String? userProfileUrl;

  const UserBasicEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.userProfileUrl,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [userId, firstName, lastName, username, userProfileUrl];
}

class StoryBasicEntity extends Equatable {
  final String id;
  final bool isViewed;

  const StoryBasicEntity({
    required this.id,
    required this.isViewed,
  });

  @override
  List<Object?> get props => [id, isViewed];
}

class PaginationDetailsEntity extends Equatable {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  const PaginationDetailsEntity({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  @override
  List<Object?> get props => [
    page, limit, totalItems, totalPages, 
    hasNextPage, hasPrevPage, nextPage, prevPage
  ];
}

// Model classes that extend entities
class FriendsStoriesModel extends FriendsStoriesEntity {
  const FriendsStoriesModel({
    required super.stories,
    required super.paginationDetails,
  });

  factory FriendsStoriesModel.fromJson(Map<String, dynamic> json) {
    return FriendsStoriesModel(
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => UserWithStoriesModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      paginationDetails: PaginationDetailsModel.fromJson(
        json['paginationDetails'] as Map<String, dynamic>
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stories': stories.map((e) => (e as UserWithStoriesModel).toJson()).toList(),
      'paginationDetails': (paginationDetails as PaginationDetailsModel).toJson(),
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
          .toList() ?? [],
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
  });

  factory StoryBasicModel.fromJson(Map<String, dynamic> json) {
    return StoryBasicModel(
      id: json['id'] ?? '',
      isViewed: json['isViewed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isViewed': isViewed,
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