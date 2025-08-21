import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../widgets/register_floating_action_button.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TruckWelcomeRideRegister extends StatelessWidget {
  const TruckWelcomeRideRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 32,
                left: 16,
                right: 16,
              ),
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
                        (index) => InkWell(
                          onTap: () {
                            ManageVibration.vibrate();
                            bottomSheet(
                              context: context,
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        width: 50,
                                        height: 50,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.asset(
                                          Assets.maleImagePlaceholder,
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                        width: 50,
                                        height: 50,
                                        padding: EdgeInsets.all(12),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.asset(
                                          Assets.phone,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: index == 0
                                    ? AppColors.GREYBG
                                    : Colors.transparent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.rideIcon,
                                  width: 50,
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
                  ),
                ],
              ),
            ),
          ),
          RegisterNextRow(
            onTap: () => context.push(Routes.truckPersonalInformationScreen),
          ),
        ],
      ),
    );
  }
}
