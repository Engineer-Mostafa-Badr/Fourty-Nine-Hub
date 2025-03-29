import 'package:equatable/equatable.dart';

class SubCategoryEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String pictureUrl;
  final bool isActive;

  const SubCategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.pictureUrl,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, nameAr, nameEn, pictureUrl];
}
