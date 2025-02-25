import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'widgets/register_floating_action_button.dart';

class WelcomeRideRegister extends StatelessWidget {
  const WelcomeRideRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: registerFloatingActionButton(
        context,
        onTap: () {
          //TODO add in logic if isTruckDriver or NormalDriver
          var isTruckDriver = true;
          if (isTruckDriver) {
            context.push(Routes.truckPersonalInformationScreen);
          } else {
            context.push(Routes.personalInformationScreen);
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: LocaleKeys.welcomeToRideRegister.localize,
              style: Styles.headerText(
                  fontWeight: FontWeight.w500,
                  color: AppColors.SECONDARY_COLOR),
            ),
            const Sizer(),
            const Sizer(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: List.generate(
                  14,
                  (index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: index == 100
                            ? AppColors.GREYBG
                            : Colors.transparent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.rideIcon,
                          width: 80.w,
                        ),
                        const Sizer(),
                        Label(
                          text: 'Captain',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
