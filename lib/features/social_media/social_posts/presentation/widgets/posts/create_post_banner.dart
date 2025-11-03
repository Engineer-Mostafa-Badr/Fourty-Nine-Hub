import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locales.dart';
import '../facebook_widgets/user_image.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';

class CreatePostBanner extends StatelessWidget {
  const CreatePostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.read<UserCubit>().isLoggedIn
              ? UserProfileImage(
                  size: 70.w,
                  userId: context.read<UserCubit>().state.data?.id ?? '',
                  imageURL:
                      context.read<UserCubit>().state.data?.profilePicture,
                  accountId: 0,
                )
              : ProfileImage(
                  size: 80.w,
                  accountId: 0,
                  userId: '',
                ),
          const Sizer(
            width: 15,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              ManageVibration.vibrate();
              !context.read<UserCubit>().isLoggedIn
                  ? pleaseLoginDialog(context)
                  // context.push(Routes.LOGIN)
                  : context.push(Routes.CREATEPOST, extra: 'facebook');
            },
            child: Container(
              width: double.infinity, // Ensure full width
              height: 50,
              padding: EdgeInsets.symmetric(
                  vertical: 10.h, horizontal: 20), // Adjust left padding
              decoration: BoxDecoration(
                color: AppColors.getFillColor(context),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Align(
                alignment: AlignmentDirectional
                    .centerStart, // Align text to center-left
                child: Label(
                  text: context.locale == Locales.english
                      ? 'What’s on your mind?'
                      : 'بم تفكر؟',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30.sp,
                      color: AppColors.getTextColor(context)),
                ),
              ),
            ),
          )),
          const Sizer(
            width: 22,
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.photo_album_outlined,
              size: 50.w,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
