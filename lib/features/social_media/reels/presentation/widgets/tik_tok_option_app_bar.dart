import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';

class TikTokOptionAppBar extends StatelessWidget {
  const TikTokOptionAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: FormTextField(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
            hint: context.isArabic ? 'فيجما' : 'Figma',
            noBorder: false,
            prefix: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                Assets.searchIcon,
                width: 20,
                height: 20,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            suffix: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CircleAvatar(
                backgroundColor: Color(0xffA2A3A3),
                child: Icon(
                  size: 13,
                  Icons.close,
                  color: context.isDarkMode ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz,
          ),
        )
      ],
    );
  }
}
