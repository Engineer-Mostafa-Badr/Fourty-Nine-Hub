import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class SelectMainCategory extends StatelessWidget {
  final List<MainCategoryEntity> mainCategories;
  final Function(MainCategoryEntity) onSelected;
  const SelectMainCategory(
      {super.key, required this.mainCategories, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leading:
            IconAppButton(icon: Icons.clear, onPressed: () => context.pop()),
        title: const Label(text: 'What are you offering?'),
      ),
      body: ListView.builder(
          itemCount: mainCategories.length,
          itemBuilder: (context, index) =>
              _buildCategoryTile(category: mainCategories[index])),
    );
  }

  Widget _buildCategoryTile({required MainCategoryEntity category}) {
    return ListTile(
      onTap: () => onSelected(category),
      leading: SquareImage(
          radius: 5,
          width: kToolbarHeight * .5,
          height: kToolbarHeight * .5,
          source: NetworkImage(category.image)),
      title: category.name == null ? null : Label(text: category.name ?? ""),
    );
  }
}
