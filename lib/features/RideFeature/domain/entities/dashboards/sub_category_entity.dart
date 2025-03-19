import 'package:equatable/equatable.dart';

class SubCategoryEntity extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;

  const SubCategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}
