import 'package:equatable/equatable.dart';

class PaginationDetailsEntity extends Equatable {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  const PaginationDetailsEntity({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  @override
  List<Object?> get props => [
        page,
        limit,
        totalItems,
        totalPages,
        hasNextPage,
        hasPrevPage,
        nextPage,
        prevPage
      ];
}