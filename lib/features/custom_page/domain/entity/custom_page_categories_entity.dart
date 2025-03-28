import 'package:equatable/equatable.dart';

class CustomPageCategoriesEntity extends Equatable {
  final String nameEn;
  final String nameAr;
  final bool enabled;
  late final bool selected;
  final String banner;

  CustomPageCategoriesEntity({
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
    required this.banner,
    this.selected = false,
  });

  @override
  List<Object> get props => [
        nameEn,
        nameAr,
        enabled,
        banner,
        selected,
      ];
}
