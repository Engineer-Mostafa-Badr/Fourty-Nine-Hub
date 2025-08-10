import 'package:equatable/equatable.dart';

class PaginatedResponseEntity<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponseEntity({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
        data,
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
        hasPreviousPage,
      ];
}