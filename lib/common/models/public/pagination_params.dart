class PaginationParams {
  int limit;
  int page;

  PaginationParams({this.limit = 30, required this.page}) {
    if (page < 1 || limit < 1) {
      throw Exception(
          'Invalid pagination params: page and limit must be greater than 0');
    }
  }

  factory PaginationParams.basic() => PaginationParams(page: 1);

  Map<String, dynamic> toJson() => {
        'limit': limit,
        'page': page,
      };
}
