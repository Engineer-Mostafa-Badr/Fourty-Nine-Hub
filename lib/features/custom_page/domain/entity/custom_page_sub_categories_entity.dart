import 'package:equatable/equatable.dart';

class CustomPageSubCategoriesEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final bool enabled;
  late bool selected;
  final String picture;

  CustomPageSubCategoriesEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
    required this.picture,
    this.selected = false,
  });

  CustomPageSubCategoriesEntity copyWith({bool? selected}) {
    return CustomPageSubCategoriesEntity(
      id: id,
      selected: selected ?? this.selected,
      enabled: enabled,
      nameEn: nameEn,
      nameAr: nameAr,
      picture: picture, // Keep original value
    );
  }

  @override
  List<Object> get props => [
        id,
        nameEn,
        nameAr,
        enabled,
        picture,
        selected,
      ];
}
