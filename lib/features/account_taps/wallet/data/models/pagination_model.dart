import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.page,
    required super.limit,
    required super.totalItems,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPrevPage,
    required super.nextPage,
    required super.prevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
      nextPage: json['nextPage'] ?? 0,
      prevPage: json['prevPage'] ?? 0,
    );
  }
}
