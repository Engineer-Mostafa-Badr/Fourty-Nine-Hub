import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePostBanner extends StatelessWidget {
  const CreatePostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.read<UserCubit>().isLoggedIn
              ? UserProfileImage(
            size: 44.w,
                  userId: context.read<UserCubit>().state.data?.id ?? '',
                  imageURL:
                      context.read<UserCubit>().state.data?.profilePicture,
                  accountId: 0,
                )
              : ProfileImage(
            size: 40.w,
                  accountId: 0,
                  userId: '',
                ),
          const Sizer(
            width: 10,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              !context.read<UserCubit>().isLoggedIn
                  ? pleaseLoginDialog(context)
              // context.push(Routes.LOGIN)
                  : context.push(Routes.CREATEPOST, extra: 'facebook');
            },
            child:Container(
              width: double.infinity, // Ensure full width
              height: 38,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12), // Adjust left padding
              decoration: BoxDecoration(
                color: AppColors.getFillColor(context),
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart, // Align text to center-left
                child: Label(
                  text: context.locale == Locales.english
                      ? 'What’s on your mind?'
                      : 'بم تفكر؟',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.getTextColor(context)
                  ),
                ),
              ),
            ),

              )),
          // const Sizer(
          //   width: 13,
          // ),
          // InkWell(
          //   onTap: () {
          //     if (context.isUserLoggedIn) {
          //       context.push(Routes.ZOOM);
          //     } else {
          //       context.push(Routes.LOGIN);
          //     }
          //   },
          //   child:  SvgPicture.asset(
          //     Assets.zoomVideo,
          //     // height: 50.h,
          //
          //   ),
          // ),
        ],
      ),
    );
  }
}
