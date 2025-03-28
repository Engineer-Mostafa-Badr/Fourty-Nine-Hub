import 'package:equatable/equatable.dart';

class SubCategoryEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String pictureUrl;

  const SubCategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.pictureUrl,
  });

  @override
  List<Object?> get props => [id, nameAr, nameEn, pictureUrl];
}
