import 'package:flutter/material.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';

import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryCard extends StatelessWidget {
  final SubCategoryEntity item;
  const SubCategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADS, extra: item.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
                      url: item.image,
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        text: item.name,
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                      const Label(text: '0 Ads')
                    ],
                  ),
                ),
                IconAppButton(
                    icon: Icons.add,
                    isCircle: true,
                    onPressed: () => context.push(Routes.CREATEAD))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
