import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyEntity emergency;
  const EmergencyCard({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: AppColors.SHADOW,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                Expanded(
                  child: Label(
                      text:
                          '${LocaleKeys.emergency.localize} ${LocaleKeys.booking.localize}: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(emergency.createdAt))}',
                      style: Styles.mediumText(
                          color: Theme.of(context).primaryColor)),
                ),
                IconButton(
                  onPressed: () {
                    bottomSheet(
                        context: context,
                        backColor: cardDarkColor(context),
                        widget: ReportView(
                          id: emergency.userId,
                          categoryId: emergency.subCategory.id,
                        ));
                  },
                  icon: const Icon(
                    Icons.report_gmailerrorred,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: AppColors.DARK_GRAY_COLOR,
          ),
          Row(
            children: [
              SquareImage(
                radius: 10,
                height: kToolbarHeight,
                width: kToolbarHeight,
                source: AssetImage(emergency.gender == 'male'
                    ? Assets.maleImagePlaceholder
                    : Assets.femaleImagePlacehlder),
              ),
              const Sizer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: emergency.name,
                        style: Styles.mediumText(
                            color: Theme.of(context).primaryColor)),
                    Label(
                        text: emergency.address,
                        style: Styles.mediumText(
                            color: AppColors.DARK_GRAY_COLOR)),
                  ],
                ),
              ),
              AppButton(
                label: LocaleKeys.call.localize,
                backColor: AppColors.PRIMARY_COLOR,
                padding: 30.w,
                onPressed: () {
                  LaunchURLHelper().call(phone: emergency.phone);
                },
                style: Styles.mediumText(color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }
}
