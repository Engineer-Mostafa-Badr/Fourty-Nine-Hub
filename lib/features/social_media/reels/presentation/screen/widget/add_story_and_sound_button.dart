import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../helpers/manage_vibration.dart';

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
                ManageVibration.vibrate();
                context.push(Routes.AddStoryScreen);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.transparent)),
              ),
              icon: SvgPicture.asset(
                Assets.musicIcon,
                width: 20,
                height: 20,
              ),
              label: Text(
                context.isArabic ? " أضف إلى القصة" : "Add to Story",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ManageVibration.vibrate();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xffFF3308)),
                side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.transparent)),
              ),
              icon: SvgPicture.asset(
                width: 20,
                height: 20,
                Assets.addSoundIcon,
              ),
              label: Text(
                context.isArabic ? "استخدم الصوت" : "use sound",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.sp,
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
