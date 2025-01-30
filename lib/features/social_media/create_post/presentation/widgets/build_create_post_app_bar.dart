import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
              onTap: ()=>Navigator.pop(context),
              child: SvgPicture.asset(Assets.backIcon,height: 18,width: 10,)),
          const SizedBox(
            width: 18,
          ),
          Text(LocaleKeys.createPost.localize,style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.PRIMARY_COLOR
          ),),
          const Spacer(),
          ClickableWidget(
              onTap: (){},
              child: Container(
            height: 38,
            width: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColors.PRIMARY_COLOR
            ),
            alignment: Alignment.center,
            child: Text(LocaleKeys.post.localize,style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColor
            ),),
          ))

        ],
      ),
    );
  }
}
