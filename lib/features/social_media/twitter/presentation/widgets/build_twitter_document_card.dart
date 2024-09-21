import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/build_meta_verified.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
            context.push(Routes.LOGIN);
          }
        },
        child: Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR_LIGHT,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logo,
                  width: 60,
                  height: 60,
                ),
                Label(
                  text: "Documentation",
                  style: Styles.headerText(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.verified,
                  color: AppColors.PRIMARY_COLOR_DARK,
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
