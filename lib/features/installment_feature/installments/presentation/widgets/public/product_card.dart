import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.INSTALLMENTDETAILS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                  child: SquareImage(
                      radius: 10, source: NetworkImage(UIConst.productImage))),
              Positioned(
                  top: 10,
                  left: 10,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.LIGHT_GRAY_COLOR,
                    child: Icon(Icons.favorite_outline),
                  ))
            ],
          )),
          Label(
              text: 'Nike Shoes',
              style: Styles.mediumText(fontWeight: FontWeight.w500)),
          Label(text: 'Nike', style: Styles.mediumText(color: Colors.grey)),
          Label(
              text: '1,500',
              style: Styles.mediumText(
                  fontSize: 20.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
