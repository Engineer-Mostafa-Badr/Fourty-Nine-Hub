class NotificationPaginationParamsModel {
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  NotificationPaginationParamsModel({
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  @override
  String toString() {
    return 'NotificationPaginationParamsModel(totalDocs: $totalDocs, limit: $limit, totalPages: $totalPages, page: $page, pagingCounter: $pagingCounter, hasPrevPage: $hasPrevPage, hasNextPage: $hasNextPage, prevPage: $prevPage, nextPage: $nextPage)';
  }

  factory NotificationPaginationParamsModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationPaginationParamsModel(
      totalDocs: json['totalDocs'] as int?,
      limit: json['limit'] as int?,
      totalPages: json['totalPages'] as int?,
      page: json['page'] as int?,
      pagingCounter: json['pagingCounter'] as int?,
      hasPrevPage: json['hasPrevPage'] as bool?,
      hasNextPage: json['hasNextPage'] as bool?,
      prevPage: json['prevPage'] as dynamic,
      nextPage: json['nextPage'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalDocs': totalDocs,
        'limit': limit,
        'totalPages': totalPages,
        'page': page,
        'pagingCounter': pagingCounter,
        'hasPrevPage': hasPrevPage,
        'hasNextPage': hasNextPage,
        'prevPage': prevPage,
        'nextPage': nextPage,
      };

  NotificationPaginationParamsModel copyWith({
    int? totalDocs,
    int? limit,
    int? totalPages,
    int? page,
    int? pagingCounter,
    bool? hasPrevPage,
    bool? hasNextPage,
    dynamic prevPage,
    dynamic nextPage,
  }) {
    return NotificationPaginationParamsModel(
      totalDocs: totalDocs ?? this.totalDocs,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      page: page ?? this.page,
      pagingCounter: pagingCounter ?? this.pagingCounter,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      prevPage: prevPage ?? this.prevPage,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}
