import 'package:equatable/equatable.dart';

class UpdateCustomPageCategoriesModel extends Equatable {
  final String mainCategoryId;
  final List<String> subcategories;

  const UpdateCustomPageCategoriesModel({
    required this.mainCategoryId,
    required this.subcategories,
  });

  UpdateCustomPageCategoriesModel copyWith({
    String? mainCategoryId,
    List<String>? subcategories,
  }) {
    return UpdateCustomPageCategoriesModel(
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainCategoryId': mainCategoryId,
      'subcategories': subcategories,
    };
  }

  @override
  List<Object?> get props => [
        mainCategoryId,
        subcategories,
      ];
}
