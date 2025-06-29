import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/screen/widget/add_story_and_sound_button.dart';
import 'package:go_router/go_router.dart';

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
          prefix: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              Assets.searchIcon,
              width: 20,
              height: 20,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                Assets.shareSoundIcon,
                color: context.isDarkMode ? Colors.white : Colors.black,
                width: 20,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const AddStoryAndSoundButton(),
      body: const UseSoundBody(),
    );
  }
}
