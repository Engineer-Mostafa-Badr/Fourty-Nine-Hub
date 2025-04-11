import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../subcategories/domain/entities/sub_category_entity.dart';

class ChooseRegisterSubcategories extends StatelessWidget {
  final List<SubCategoryEntity> subCategories;
  final Function(SubCategoryEntity) onSelection;
  const ChooseRegisterSubcategories(
      {super.key, required this.subCategories, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: BackAppBar(
          label: 'Choose Options',
        ),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            final item = subCategories[index];
            return InkWell(
              onTap: () => onSelection(item),
              child: Column(
                children: [
                  Expanded(
                      child: SquareImage(
                    url: item.image,
                  )),
                  Label(text: context.isArabic ? item.nameAr : item.nameEn)
                ],
              ),
            );
          }),
    );
  }
}
