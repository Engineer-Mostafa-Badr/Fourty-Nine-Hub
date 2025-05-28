import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/Social_home.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BuildCreatePostAppBar extends StatelessWidget {
  const BuildCreatePostAppBar({super.key, this.onTap});
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10, end: 15, start: 15),
      child: Row(
        children: [
          ClickableWidget(
              onTap: (){
                context.go(Routes.SOCIAL,
                    extra: SocialParams(
                        userId: UserCubit.to.state.data?.id ?? '', index: 0));
              },
              child: Icon(Icons.arrow_back_ios_new)),
          const SizedBox(
            width: 18,
          ),
          Text(LocaleKeys.createPost.localize,style:  TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color:context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR
          ),),
          const Spacer(),
          ClickableWidget(
              onTap: onTap,
              child: Container(
            height: 38,
            width: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColors.getButtonPrimaryColor(context)
            ),
            alignment: Alignment.center,
            child: Text(LocaleKeys.post.localize,style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.getReversedTextColor(context)
            ),),
          ))

        ],
      ),
    );
  }
}
