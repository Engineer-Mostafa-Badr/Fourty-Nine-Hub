import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../res/style/styles.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CreatePostBanner extends StatelessWidget {
  const CreatePostBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.read<UserCubit>().isLoggedIn
              ? UserProfileImage(
                  userId: context.read<UserCubit>().state.data?.id ?? '',
                  imageURL:
                      context.read<UserCubit>().state.data?.profilePicture,
                  accountId: 0,
                )
              : const ProfileImage(
                  accountId: 0,
                  userId: '',
                ),
          Sizer(
            width: 10,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              !context.read<UserCubit>().isLoggedIn
                  ? context.push(Routes.LOGIN)
                  : context.push(Routes.CREATEPOST, extra: 'facebook');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: .5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Label(
                text: 'What do you think about?',
                style: Styles.mediumText(color: Colors.grey),
              ),
            ),
          )),
          Sizer(
            width: 10,
          ),
          InkWell(
            onTap: () => context.push(Routes.REELS),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.reels,
                  height: 20.h,
                ),
                Sizer(
                  height: 3.h,
                ),
                Label(
                  text: 'Reel',
                  style: Styles.smallText(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
