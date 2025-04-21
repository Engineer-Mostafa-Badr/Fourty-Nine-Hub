import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AddStoryAndSoundButton extends StatelessWidget {
  const AddStoryAndSoundButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                context.pushNamed(Routes.AddStoryScreen);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.transparent)),
              ),
              icon: SvgPicture.asset(Assets.musicIcon),
              label: Text(
                context.isArabic ? " أضف إلى القصة" : "Add to Story",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xffFF3308)),
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.transparent)),
              ),
              icon: SvgPicture.asset(Assets.addSoundIcon),
              label: Text(
                context.isArabic ? "استخدم الصوت" : "use sound",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
