// build_twitter_document_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';

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
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.isArabic;
    return BlocConsumer<TwitterCubit, TwitterState>(
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
        return ClickableWidget(
          onTap: () {
            final isLoggedIn = context.read<UserCubit>().isLoggedIn;
            if (isLoggedIn) {
              bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: BlocProvider.value(
                    value: serviceLocator<TwitterCubit>(),
                    child: const BuildMetaVerified()),
              );
            } else {
              pleaseLoginDialog(context);
            }
          },
          child: SizedBox(
            height: 220.h,
            width: double.infinity,
            child: Card(
              color: AppColors.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image with Icon
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 12.h),
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                        // image: const DecorationImage(
                        //   image: AssetImage("assets/meta_verified_bg.png"), // your background
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.verified,
                          color: Colors.blueAccent,
                          size: 65,
                        ),
                      ),
                    ),
                  ),
                  // Bottom Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Small verified badge
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Texts
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${49} ${LocaleKeys.verification.localize}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              context.isArabic?"بناء الثقة مع شارة التحقق.":"Build trust with a verified badge.",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.3),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
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
    );
  }
}
