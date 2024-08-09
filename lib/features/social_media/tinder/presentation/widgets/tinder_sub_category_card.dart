import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TinderSubCategoryCard extends StatelessWidget {
  final SubCategoryData subCategory;

  const TinderSubCategoryCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 2,
          child: Column(
            children: [
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SquareImage(
                        fit: BoxFit.fitWidth,
                        radius: 10,
                        url: subCategory.picture,
                      ),
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: IconAppButton(
                            size: 20,
                            icon: Icons.favorite_border,
                            color: Colors.red,
                            onPressed: () {}))
                  ],
                ),
              )),
              const Sizer(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: subCategory.nameEn ?? '',
                          style: Styles.headerText(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                        Label(
                          text: '${9355.toShortScale} ads',
                          style: Styles.mediumText(fontSize: 14),
                        ),
                      ],
                    ),
                    IconAppButton(
                      icon: Icons.add,
                      isCircle: true,
                      color: Colors.white,
                      backColor: AppColors.PRIMARY_COLOR,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
