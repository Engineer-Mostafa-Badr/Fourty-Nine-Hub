import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';

class SubTitleAndNameUnderHeaderInstagram extends StatelessWidget {
  const SubTitleAndNameUnderHeaderInstagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: context.read<ProfileInstagramCubit>().state.profileData!.bio,
            style: Styles.mediumText(),
          ),
          const SizedBox(
            height: 17,
          ),
          Row(
            children: [
              SvgPicture.asset(
                context.isDarkMode ? Assets.aMailIconDark : Assets.aMailIcon,
              ),
              const SizedBox(
                width: 3,
              ),
              Label(
                text: context
                    .read<ProfileInstagramCubit>()
                    .state
                    .profileData!
                    .username,
                style: Styles.headerText(
                  fontSize: 24,
                  height: 1.33,
                ),
              ),
              // const SizedBox(
              //   width: 12,
              // ),
              // SvgPicture.asset(
              //   Assets.facebook2Icon,
              // ),
              // Label(
              //   text: ' ahmed mohamed',
              //   style: Styles.headerText(
              //     fontSize: 24,
              //     height: 1.33,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
