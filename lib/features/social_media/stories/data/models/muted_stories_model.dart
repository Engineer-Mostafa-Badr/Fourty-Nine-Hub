import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';

class MutedStoriesResponse {
  final bool status;
  final String message;
  final MutedStoriesData data;

  MutedStoriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MutedStoriesResponse.fromJson(Map<String, dynamic> json) {
    return MutedStoriesResponse(
      status: json['status'],
      message: json['message'],
      data: MutedStoriesData.fromJson(json['data']),
    );
  }
}

class MutedStoriesData {
  final List<UserStories> stories;
  final Pagination pagination;

  MutedStoriesData({
    required this.stories,
    required this.pagination,
  });

  factory MutedStoriesData.fromJson(Map<String, dynamic> json) {
    return MutedStoriesData(
      stories: (json['stories'] as List)
          .map((i) => UserStories.fromJson(i))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}




class Pagination {
  final int countItem;
  final int pageCount;
  final int currentPage;

  Pagination({
    required this.countItem,
    required this.pageCount,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      countItem: json['countItem'],
      pageCount: json['pageCount'],
      currentPage: json['currentPage'],
    );
  }
}
