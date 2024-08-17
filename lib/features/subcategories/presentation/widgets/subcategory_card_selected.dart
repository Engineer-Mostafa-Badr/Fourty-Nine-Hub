import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SubcategoryCardSelected extends StatefulWidget {
  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;
  final bool selected;
  const SubcategoryCardSelected(
      {super.key,
      required this.item,
      required this.mainCategory,
      required this.selected});

  @override
  State<SubcategoryCardSelected> createState() =>
      _SubcategoryCardSelectedState();
}

class _SubcategoryCardSelectedState extends State<SubcategoryCardSelected> {
  // bool checkbox = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kToolbarHeight * 2.5,
      height: kToolbarHeight * 3,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.selected ? Colors.red : Colors.transparent,
              width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                offset: Offset(-1, 1),
                blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SquareImage(
                    fit: BoxFit.cover,
                    radius: 5,
                    url: widget.item.image,
                  ),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconAppButton(
                        icon: Icons.favorite_outline, onPressed: () {}))
              ],
            ),
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: widget.item.name,
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                      const Label(text: '0 Ads')
                    ],
                  ),
                ),
                Checkbox(
                  value: widget.selected,
                  onChanged: (value) {},
                )
                // IconAppButton(
                //     icon: Icons.,
                //     size: 20,
                //     onPressed: () {
                //       if (AuthHelper().isLoggedIn()) {
                //         context.push(Routes.CREATEAD,
                //             extra: CategorizationEntity(
                //                 mainCategory: mainCategory,
                //                 subCategory: item));
                //       } else {
                //         context.push(Routes.LOGIN);
                //       }
                //     })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
