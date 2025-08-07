import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
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
    return BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? UnknownFailure(''),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      context.read<TwitterCubit>();
      return InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (context.read<UserCubit>().isLoggedIn) {
            bottomSheet(
              context: context,
              isScrollControlled: true,
              widget: const BuildMetaVerified(),
            );
          } else {
            return pleaseLoginDialog(context);

            // context.push(Routes.LOGIN);
          }
        },
        child: Container(
          height: 120.h,
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logo,
                  width: 60,
                  height: 60.h,
                ),
                Label(
                  text: LocaleKeys.verification.localize,
                  style: Styles.headerText(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.verified,
                  color: AppColors.blueColor,
                  size: 25,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
