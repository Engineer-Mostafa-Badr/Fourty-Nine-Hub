import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  PaginationModel(
      {required super.page,
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
      page: json['page'] ,
      limit: json['limit'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }
}
