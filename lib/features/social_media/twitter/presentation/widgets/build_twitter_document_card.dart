// build_twitter_document_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../bloc/twitter_bloc.dart';
import 'build_meta_verified.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../common/widgets/dialogs/please_login_dialog.dart';

class BuildTwitterDocumentCard extends StatefulWidget {
  const BuildTwitterDocumentCard({super.key});

  @override
  State<BuildTwitterDocumentCard> createState() =>
      _BuildTwitterDocumentCardState();
}

class _BuildTwitterDocumentCardState extends State<BuildTwitterDocumentCard> {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.isArabic;
    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator<TwitterCubit>()..loadGlobalData(),
      child: BlocConsumer<TwitterCubit, TwitterState>(
        listener: (context, state) {
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(state.failure ?? UnknownFailure(''), context),
            );
          }
        },
        builder: (context, state) {
          final rowChildren = <Widget>[
            // LTR: logo -> label -> icon
            // RTL: will be reversed below
            Image.asset(Assets.logo, width: 60, height: 60.h),
            SizedBox(width: 10.w),
            Label(
              text: LocaleKeys.verification.localize, // already localized
              style: Styles.headerText(color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.verified, color: AppColors.blueColor, size: 25),
          ];

          return InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              final isLoggedIn = context.read<UserCubit>().isLoggedIn;
              if (isLoggedIn) {
                bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: const BuildMetaVerified(),
                );
              } else {
                pleaseLoginDialog(context);
              }
            },
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                height: 120.h,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: isArabic
                        ? rowChildren.reversed.toList()
                        : rowChildren,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
