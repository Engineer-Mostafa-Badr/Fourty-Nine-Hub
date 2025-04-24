class DataSuggestFollowInstagramEntity {
  final List<SuggestionEntity> suggestions;
  final PaginationDetailsEntity paginationDetails;

  DataSuggestFollowInstagramEntity({
    required this.suggestions,
    required this.paginationDetails,
  });
}

class SuggestionEntity {
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final List<FollowerEntity> followers;

  SuggestionEntity({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    required this.followers,
  });
}

class FollowerEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;

  FollowerEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });
}

class PaginationDetailsEntity {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationDetailsEntity({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
}
