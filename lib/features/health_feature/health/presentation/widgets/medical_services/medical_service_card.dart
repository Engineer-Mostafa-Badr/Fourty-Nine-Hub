import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HealthMedicalServiceCard extends StatelessWidget {
  final SubCategoryEntity subCategory;
  const HealthMedicalServiceCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ]),
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
                      url: subCategory.image,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Label(
                      text: subCategory.name,
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                    Label(
                      text: '${9355.toShortScale} ads',
                      style: Styles.mediumText(),
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
          ],
        ),
      ),
    );
  }
}
