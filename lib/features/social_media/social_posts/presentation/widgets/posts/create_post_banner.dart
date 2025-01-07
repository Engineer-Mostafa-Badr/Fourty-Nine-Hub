import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.read<UserCubit>().isLoggedIn
              ? UserProfileImage(
            size: 40.w,
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
                  ? context.push(Routes.LOGIN)
                  : context.push(Routes.CREATEPOST, extra: 'facebook');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: .5),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Label(
                text: context.locale == Locales.english
                    ? 'What on your mind?'
                    : 'بم تفكر؟',
                style: Styles.mediumText(color: Colors.grey),
              ),
            ),
          )),
          const Sizer(
            width: 50,
          ),
          InkWell(
            onTap: () {
              if (context.isUserLoggedIn) {
                context.push(Routes.ZOOM);
              } else {
                context.push(Routes.LOGIN);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.zoomMeeting,
                  height: 50.h,

                ),
                Sizer(
                  height: 3.h,
                ),
                Label(
                  text: LocaleKeys.meet.localize,
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
