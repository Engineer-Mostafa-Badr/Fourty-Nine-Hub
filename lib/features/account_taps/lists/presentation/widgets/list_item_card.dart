import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../cubit/lists_cubit.dart';

class ListItemCard extends StatelessWidget {
  final UserFriendEntity user;
  final ListTypes type;

  const ListItemCard(
      {super.key,
      required this.user,
      required this.type,
      required this.removeRequest,
      required this.acceptRequest,
      required this.unblockUser,
      required this.unfollowUser,
      required this.deleteFriend});

  final Function(AcceptRejectFriendRequestParams) removeRequest;
  final Function(AcceptRejectFriendRequestParams) acceptRequest;
  final Function(String) unblockUser;
  final Function(String) deleteFriend;
  final Function(String) unfollowUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListsCubit, ListsState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            UserProfileImage(
              accountId: 0,
              imageURL: user.image,
              userId: '',
              fromProfile: true,
            ),
            const Sizer(),
            Expanded(child: Label(text: "${user.firstName}\t${user.lastName}")),
            const Sizer(),
            if (type == ListTypes.requests)
              IconButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    acceptRequest(AcceptRejectFriendRequestParams(
                        userId: user.id, status: true));
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  )),
            if (type == ListTypes.requests)
              IconButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    removeRequest(AcceptRejectFriendRequestParams(
                        userId: user.id, status: false));
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  )),
            IconButton(
                onPressed: () {
                  ManageVibration.vibrate();
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: _buildOptionsBottomSheet(context));
                },
                icon: const Icon(Icons.more_horiz)),
          ],
        ),
      );
    });
  }

  Widget _buildOptionsBottomSheet(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          onTap: () {
            ManageVibration.vibrate();
            context.push(Routes.OTHERSACCOUNT, extra: user.id);
          },
          leading: const Icon(Icons.person),
          title: Label(
              text:
                  '${LocaleKeys.view.localize} ${LocaleKeys.profile.localize} ${user.firstName} '),
        ),
        if (type != ListTypes.blocked)
          ListTile(
            onTap: () => context.push(Routes.CHATROOM),
            leading: const Icon(Icons.chat),
            title: Label(
                text: '${LocaleKeys.chatWith.localize} ${user.firstName}'),
          ),
        if (type == ListTypes.followers)
          ListTile(
            leading: const Icon(Icons.clear),
            title: Label(
              text: '${LocaleKeys.unFollow.localize} ${user.firstName}',
              style: Styles.mediumText(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              ManageVibration.vibrate();
              unfollowUser(user.id);
              context.pop();
            },
            subtitle: Label(
              text: '${LocaleKeys.stopSeeing.localize} ${user.firstName}',
              maxLines: 2,
            ),
          ),
        if (type == ListTypes.blocked)
          ListTile(
            leading: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            onTap: () {
              ManageVibration.vibrate();
              unblockUser(user.id);
              context.pop();
            },
            title: Label(
              text: '${LocaleKeys.unblock.localize} ${user.firstName}',
              style: Styles.mediumText(
                  color: Colors.green, fontWeight: FontWeight.w600),
            ),
            subtitle: Label(
              text:
                  '${LocaleKeys.youCanRemove.localize} ${user.firstName} ${LocaleKeys.fromBlockedList.localize}',
            ),
          ),
        if (type == ListTypes.requests)
          ListTile(
            leading: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            onTap: () {
              ManageVibration.vibrate();
              acceptRequest(AcceptRejectFriendRequestParams(
                  userId: user.id, status: true));
              context.pop();
            },
            title: Label(
              text:
                  '${LocaleKeys.Accept.localize} ${LocaleKeys.friendRequest.localize} ${user.firstName}',
              style: Styles.mediumText(
                  color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ),
        if (type == ListTypes.requests)
          ListTile(
            leading: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              ManageVibration.vibrate();
              removeRequest(AcceptRejectFriendRequestParams(
                  userId: user.id, status: false));
              context.pop();
            },
            title: Label(
              text:
                  '${LocaleKeys.reject.localize} ${LocaleKeys.friendRequest.localize} ${user.firstName}',
              style: Styles.mediumText(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        if (type == ListTypes.friends)
          ListTile(
            leading: const Icon(
              Icons.block_flipped,
              color: Colors.red,
            ),
            onTap: () {
              ManageVibration.vibrate();
              deleteFriend(user.id);
              context.pop();
            },
            title: Label(
              text: '${LocaleKeys.unfriend.localize} ${user.firstName}',
              style: Styles.mediumText(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
            subtitle: Label(
              text:
                  '${LocaleKeys.youCanRemove.localize} ${user.firstName} ${LocaleKeys.fromFriendsList.localize}',
            ),
          ),
      ],
    );
  }
}
