import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/common_group_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/create_group_with_contact_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_chat_lock_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_custom_divider.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_incription_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_status_cart.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ViewContactView extends StatelessWidget {
  const ViewContactView({super.key, required this.sender});

  final String sender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.PRIMARY_COLOR,
        // title: Text(
        //   'Ahmed Nasr',
        //   style: Styles.headerText(
        //     fontWeight: FontWeight.bold,
        //     color: AppColors.BACKGROUND_COLOR,
        //   ),
        // ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 26,
            color: AppColors.BACKGROUND_COLOR,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const CircleAvatar(
            // backgroundColor: Colors.transparent,
            radius: 54,
            backgroundImage: CachedNetworkImageProvider(
              UIConst.profilePlaceHolder,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            sender,
            style: Styles.headerText(
              fontWeight: FontWeight.bold,
              color: context.isDarkMode
                  ? AppColors.BACKGROUND_COLOR
                  : AppColors.PRIMARY_COLOR,
            ),
          ),
          const ViewContactCustomDivider(),
          const ViewContactStatusCart(),
          const ViewContactCustomDivider(),
          const ViewContactEncriptionCart(),
          const SizedBox(
            height: 16,
          ),
          const ViewContactChatLockCart(),
          const ViewContactCustomDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '1 ${LocaleKeys.createGroup.tr()}',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w400,
                    color: AppColors.DARK_GRAY_COLOR,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const CreateGroupWithContactCart(),
          const SizedBox(
            height: 16,
          ),
          const CommonGroupCart(),
        ],
      ),
    );
  }
}
