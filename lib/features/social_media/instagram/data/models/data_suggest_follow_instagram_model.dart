import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';

class DataSuggestFollowInstagramModel extends DataSuggestFollowInstagramEntity {
  DataSuggestFollowInstagramModel({
    required super.suggestions,
    required super.paginationDetails,
  });

  factory DataSuggestFollowInstagramModel.fromJson(Map<String, dynamic> json) {
    return DataSuggestFollowInstagramModel(
      suggestions: (json['suggestions'] as List?)
              ?.map((s) => SuggestionModel.fromJson(s))
              .toList() ??
          [],
      paginationDetails: PaginationDetailsModel.fromJson(
        json['paginationDetails'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class SuggestionModel extends SuggestionEntity {
  SuggestionModel({
    required super.userId,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureUrl,
    required super.followers,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
        userId: json['userId'] ?? '',
        username: json['username'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        profilePictureUrl: json['profilePictureUrl'] ?? '',
        followers: List<FollowerModel>.from(
          (json['followers'] as List?)
                  ?.map((f) => FollowerModel.fromJson(f))
                  .toList() ??
              [],
        ));
  }
}

class FollowerModel extends FollowerEntity {
  FollowerModel({
    required super.id,
    required super.username,
    required super.firstName,
    required super.lastName,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class PaginationDetailsModel extends PaginationDetailsEntity {
  PaginationDetailsModel({
    required super.page,
    required super.limit,
    required super.totalItems,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPrevPage,
  });

  factory PaginationDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaginationDetailsModel(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
