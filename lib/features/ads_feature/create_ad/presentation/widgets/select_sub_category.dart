import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class SelectSubCategory extends StatelessWidget {
  final List<SubCategoryEntity> subCategories;
  final Function(SubCategoryEntity) onSelected;
  const SelectSubCategory(
      {super.key, required this.subCategories, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconAppButton(icon: Icons.clear, onPressed: () => context.pop()),
        title: const Label(text: 'What are you offering?'),
      ),
      body: ListView.builder(
          itemCount: subCategories.length,
          itemBuilder: (context, index) => _buildCategoryTile(
              category: subCategories[index], context: context)),
    );
  }

  Widget _buildCategoryTile(
      {required SubCategoryEntity category, required BuildContext context}) {
    return ListTile(
      onTap: () => onSelected(category),
      leading: SquareImage(
          radius: 5,
          width: kToolbarHeight * .5,
          height: kToolbarHeight * .5,
          source: NetworkImage(category.image)),
      title: Label(text: context.isArabic ? category.nameAr : category.nameEn),
    );
  }
}
