class PaginationParams {
  int limit;
  int page;
  PaginationParams({this.limit = 10, required this.page});

  factory PaginationParams.basic() => PaginationParams(page: 1);

  Map<String, dynamic> toJson() => {
        'limit': limit,
        'page': page,
      };
}
