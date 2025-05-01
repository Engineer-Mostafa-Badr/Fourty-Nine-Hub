import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/screen/widget/add_story_and_sound_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../res/assets/assets.dart';
import 'widget/use_sound_body.dart';

class UseSoundScreen extends StatelessWidget {
  const UseSoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: FormTextField(
          fillColor: Colors.white,
          borderSide: Colors.black,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SvgPicture.asset(
              Assets.searchSoundIcon,
            ),
          ),
          hint: "اغنية عمرو دياب ",
          borderColor: context.isDarkMode ? Colors.white : Colors.black,
          noBorder: false,
          style: TextStyle(
            color: context.isDarkMode ? Colors.white : Colors.grey.shade600,
          ),
          //   fillColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                Assets.shareSoundIcon,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AddStoryAndSoundButton(),
      body: const UseSoundBody(),
    );
  }
}
