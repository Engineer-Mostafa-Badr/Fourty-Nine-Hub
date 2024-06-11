import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';

class DriverDashboardBanner extends StatelessWidget {
  const DriverDashboardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> context.push(Routes.RIDERDASHBOARD),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Driver Dashboard\n',
                    style: Styles.mediumText(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'New trips are waiting you, go to driver dashboard and explore more!',
                    style: Styles.mediumText(
                      color: Colors.white,
                    ),
                  ),
                ])),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              ),
            ],
          )),
    );
  }
}
