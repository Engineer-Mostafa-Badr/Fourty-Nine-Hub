import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class SubCategoryCard extends StatelessWidget {
  const SubCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADS),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: SquareImage(
                        radius: 10,
                        source: NetworkImage(UIConst.imagePlaceHolder)),
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
                        text: 'Ride Sub',
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                      const Label(text: '14 Ads')
                    ],
                  ),
                ),
                IconAppButton(icon: Icons.add, isCircle: true, onPressed: () {})
              ],
            ),
          ],
        ),
      ),
    );
  }
}
