class StoriesResponse {
  final bool? status;
  final String? message;
  final StoriesData? data;

  StoriesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StoriesResponse();
    return StoriesResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? StoriesData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}

class StoriesData {
  final List<UserStories>? userStories;
  final PaginationData? pagination;

  StoriesData({
    this.userStories,
    this.pagination,
  });

  factory StoriesData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StoriesData();
    return StoriesData(
      userStories: (json['stories'] as List<dynamic>?)
          ?.map((e) => UserStories.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stories': userStories?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}

class UserStories {
  final UserData? user;
  final List<Story>? stories;

  UserStories({
    this.user,
    this.stories,
  });

  factory UserStories.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserStories();
    return UserStories(
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'stories': stories?.map((e) => e.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }
}

class Story {
  final String? id;
  final int? viewCount;
  final String? type;
  final String? content;
  final String? caption;
  final String? thumbnailUrl;
  final DateTime? createdAt;
  final String? color;
  final String? fontFamily;
  bool isLiked;

  Story({
    this.id,
    this.viewCount,
    this.type,
    this.content,
    this.caption,
    this.thumbnailUrl,
    this.createdAt,
    this.color,
    this.fontFamily,
    this.isLiked = false,
  });

  factory Story.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Story();
    return Story(
      id: json['_id'] as String?,
      viewCount: json['viewCount'] as int?,
      type: json['type'] as String?,
      content: json['content'] as String?,
      caption: json['caption'] as String?,
      thumbnailUrl: json['thumbnailSignedUrl'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      color: json['color'] as String?,
      fontFamily: json['fontFamily'] as String?,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'viewCount': viewCount,
      'type': type,
      'content': content,
      'caption': caption,
      'thumbnailSignedUrl': thumbnailUrl,
      'createdAt': createdAt?.toIso8601String(),
      'color': color,
      'fontFamily': fontFamily,
      'isLiked': isLiked,
    }..removeWhere((key, value) => value == null);
  }
}

class UserData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePictureUrl;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserData();
    return UserData(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureUrl: json['profilePictureSignedUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureSignedUrl': profilePictureUrl,
    }..removeWhere((key, value) => value == null);
  }
}

class PaginationData {
  final int? countItem;
  final int? pageCount;
  final int? currentPage;

  PaginationData({
    this.countItem,
    this.pageCount,
    this.currentPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PaginationData();
    return PaginationData(
      countItem: json['countItem'] as int?,
      pageCount: json['pageCount'] as int?,
      currentPage: json['currentPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countItem': countItem,
      'pageCount': pageCount,
      'currentPage': currentPage,
    }..removeWhere((key, value) => value == null);
  }
}
