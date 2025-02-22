import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets/dynamic/sizer.dart';
import '../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../common/widgets/stateless/labels/label.dart';
import '../../core/localization/locale_keys.g.dart';
import '../../core/widget/custom_scaffold.dart';
import '../../res/style/app_colors.dart';
import '../../res/style/styles.dart';

class DriversLicenseScreen extends StatelessWidget {
  const DriversLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController licenseNumberController = TextEditingController();
    TextEditingController expirationDateController = TextEditingController();
    return CustomScaffold(
      appBar: const HomeAppbar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Sizer(),
          // Sizer(),
          // Sizer(),
          Expanded(
            child: Container(
              height: 8.h,
              color: Colors.red,
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // margin: const EdgeInsets.symmetric(horizontal: 16.0),

            ),
          ),
          const Sizer(),
          Container(
            height: 60.h,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.GREY_LIGHT_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const Sizer(),
          Container(
            height: 60.h,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Label(
                  text: LocaleKeys.next,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w400,
                    color: AppColors.AUTH_CONTAINER_COLOR,
                  ),
                ),
                const Sizer(),
                const Sizer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.AUTH_CONTAINER_COLOR,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.close,
                  // size: ,
                  color: AppColors.PRIMARY_COLOR,
                ),
                Label(
                  text: 'Close',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Label(
              text: 'Personal information',
              style: Styles.headerText(
                  fontWeight: FontWeight.w500,
                  color: AppColors.SECONDARY_COLOR),
            ),
            const Sizer(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                mainAxisSpacing: 32.w,
                crossAxisSpacing: 32.h,
                children: List.generate(
                  14,
                      (index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:index==100? AppColors.GREY_LIGHT_COLOR:Colors.transparent
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.GREY_LIGHT_COLOR,
                              ),
                              height: 200.w,
                              width: 200.w,
                              child: const Icon(
                                Icons.add,
                                size: 30,
                                color: AppColors.PRIMARY_COLOR,
                              ),
                            ),
                            const Sizer(),
                            Label(
                              text: 'Personal Picture',
                              style: Styles.mediumText(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Sizer(),
            DefaultTextFormField(
              currentController: licenseNumberController,
              fillColor: AppColors.GREY_LIGHT_COLOR,
              borderColor: Colors.transparent,
              hint: 'License Number',
            ),
            const Sizer(),
            DefaultTextFormField(
              currentController: expirationDateController,
              fillColor: AppColors.GREY_LIGHT_COLOR,
              borderColor: Colors.transparent,
              hint: 'Expiration Date',
            ),
          ],
        ),
      ),
    );
  }
}
