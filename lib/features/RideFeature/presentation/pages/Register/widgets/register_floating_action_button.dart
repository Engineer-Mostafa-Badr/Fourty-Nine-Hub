import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RegisterNextRow extends StatelessWidget {
  const RegisterNextRow({super.key, this.index, this.onTap});

  final int? index;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32,top: 8.0,right: 12,left: 12,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (index != null)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    text: '$index Of 5',
                    style: Styles.mediumText(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: index!,
                        child: Container(
                          height: 4,
                          width: 100,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      Expanded(
                        flex: 5 - index!,
                        child: Container(
                          height: 2,
                          color: AppColors.GREY_BORDER_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const Sizer(),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.GREYBG,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
              const Sizer(),
              InkWell(
                onTap: onTap,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Label(
                        text: index == 5
                            ? LocaleKeys.submit.localize
                            : context.isArabic?'التالي':'Next',
                        style: Styles.headerText(
                          fontWeight: FontWeight.w400,
                          color: AppColors.AUTH_CONTAINER_COLOR,
                        ),
                      ),
                      const Sizer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.AUTH_CONTAINER_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget registerFloatingActionButton(
//   context, {
//   int? index,
//   void Function()? onTap,
// }) {}
