import 'package:equatable/equatable.dart';

class CustomPageCategoriesEntity extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final bool enabled;
  late bool selected;
  final String banner;
  final List<String> subCategories;

  CustomPageCategoriesEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
    required this.banner,
    required this.subCategories,
    this.selected = false,
  });

  CustomPageCategoriesEntity copyWith({
    String? id,
    String? nameEn,
    String? nameAr,
    bool? enabled,
    String? banner,
    bool? selected,
    List<String>? subCategories,
  }) {
    return CustomPageCategoriesEntity(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      enabled: enabled ?? this.enabled,
      banner: banner ?? this.banner,
      selected: selected ?? this.selected,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  @override
  List<Object> get props => [
        id,
        nameEn,
        nameAr,
        enabled,
        banner,
        selected,
        subCategories,
      ];
}
