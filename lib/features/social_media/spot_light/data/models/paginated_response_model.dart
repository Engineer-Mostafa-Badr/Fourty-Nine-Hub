import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/paginated_response_entity.dart';

class PaginatedResponseModel<T> extends PaginatedResponseEntity<T> {
  const PaginatedResponseModel({
    required super.data,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<dynamic> dataList = json['data'] ?? [];
    final List<T> data = dataList
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponseModel<T>(
      data: data,
      currentPage: json['currentPage'] ?? json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? json['total'] ?? data.length,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}