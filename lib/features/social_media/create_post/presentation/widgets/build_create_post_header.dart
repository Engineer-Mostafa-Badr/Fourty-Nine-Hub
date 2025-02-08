import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_drop_down.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class BuildCreatePostHeader extends StatelessWidget {
  const BuildCreatePostHeader({super.key,required this.sheetController,required this.controller,required this.state});
  final SheetController sheetController;
  final CreatePostCubit controller;
  final CreatePostState state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 53,
            height: 53,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.GREYBG
            ),
            child: Center(
              child: SvgPicture.asset(Assets.maleIcon,width: 32,height: 35,),
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mohemed Gamal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: ()async{
                        sheetController.collapse();
                        final res = await CustomVerticalSheetItem.normal<
                            PrivacyStatus>(context, [
                          CustomSheetModel(
                            text: LocaleKeys.public.localize,
                            value: PrivacyStatus.public,
                            iconData: Icons.language,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.friends.localize,
                            value: PrivacyStatus.friends,
                            iconData: Icons.family_restroom,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.followers.localize,
                            value: PrivacyStatus.followers,
                            iconData: Icons.accessibility_sharp,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.friendsAndFollowers.localize,
                            value: PrivacyStatus.friendsAndFollowers,
                            iconData: Icons.supervised_user_circle_outlined,
                          ),
                          CustomSheetModel(
                            text: LocaleKeys.onlyMe.localize,
                            value: PrivacyStatus.onlyMe,
                            iconData: Icons.lock,
                          ),
                        ]);
                        print(res?.name);
                        print("============>");
                        controller.selectPrivacy(
                            privacy: res?.name ?? 'public');
                      },
                      child:BuildDropDown(icon:Assets.publicIcon,text:  state.selectedPrivacy == 'onlyMe'
                          ? LocaleKeys.onlyMe.localize
                          : state.selectedPrivacy == 'friends'
                          ? LocaleKeys.friends.localize
                          : state.selectedPrivacy == 'followers'
                          ? LocaleKeys.followers.localize
                          : state.selectedPrivacy ==
                          'friendsAndFollowers'
                          ? LocaleKeys.friendsAndFollowers
                          .localize
                          : LocaleKeys.public.localize,width: 16,height: 16,),
                    )

                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                // Dropdown Buttons
                Row(
                  children: [
                    BuildDropDown(icon:Assets.onInstaIcon,text: 'Off',width: 10,height: 10),
                    const SizedBox(width: 5),
                    BuildDropDown(icon:Assets.onTweetIcon,text: 'Off'),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
