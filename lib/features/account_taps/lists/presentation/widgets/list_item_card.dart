import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/publisher_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../cubit/lists_cubit.dart';

class ListItemCard extends StatelessWidget {
  final UserEntity user;
  final ListTypes type;
  const ListItemCard({super.key, required this.user, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Row(
    //   children: [
    //     ProfileImage(
    //       accountId:0,
    //       imageURL: user.profilePicture,
    //     ),
    //     const Sizer(),
    //     Expanded(child: Label(text: user.name)),
    //     const Sizer(),
    //     if (type == ListTypes.requests)
    //       IconButton(
    //           onPressed: () {},
    //           icon: const Icon(
    //             Icons.check,
    //             color: Colors.green,
    //           )),
    //     if (type == ListTypes.requests)
    //       IconButton(
    //           onPressed: () {},
    //           icon: const Icon(
    //             Icons.clear,
    //             color: Colors.red,
    //           )),
    //     IconButton(
    //         onPressed: () {
    //           bottomSheet(
    //               context: context,
    //               isScrollControlled: true,
    //               widget: _buildOptionsBottomSheet(context));
    //         },
    //         icon: const Icon(Icons.more_horiz)),
    //   ],
    // );
  }

  // Widget _buildOptionsBottomSheet(BuildContext context) {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       ListTile(
  //         onTap: () => context.push(Routes.OTHERSACCOUNT, extra: user.id),
  //         leading: const Icon(Icons.person),
  //         title: Label(text: 'View ${user.name} Profile'),
  //       ),
  //       if (type != ListTypes.blocked)
  //         ListTile(
  //           onTap: () => context.push(Routes.CHATROOM, extra: user.id),
  //           leading: const Icon(Icons.chat),
  //           title: Label(text: 'Chat with ${user.name}'),
  //         ),
  //       if (type == ListTypes.friends)
  //         ListTile(
  //           leading: const Icon(Icons.clear),
  //           title: Label(
  //             text: 'Unfollow ${user.name}',
  //             style: Styles.mediumText(fontWeight: FontWeight.w600),
  //           ),
  //           subtitle: Label(
  //             text:
  //                 'Stop seeing ${user.name} posts while keeping him as a friend',
  //           ),
  //         ),
  //       if (type == ListTypes.blocked)
  //         ListTile(
  //           leading: const Icon(
  //             Icons.check,
  //             color: Colors.green,
  //           ),
  //           title: Label(
  //             text: 'Unblock ${user.name}',
  //             style: Styles.mediumText(
  //                 color: Colors.green, fontWeight: FontWeight.w600),
  //           ),
  //           subtitle: Label(
  //             text: 'You can remove ${user.name} from blocked list',
  //           ),
  //         ),
  //       if (type == ListTypes.requests)
  //         ListTile(
  //           leading: const Icon(
  //             Icons.check,
  //             color: Colors.green,
  //           ),
  //           title: Label(
  //             text: 'Accept ${user.name} Friend Request',
  //             style: Styles.mediumText(
  //                 color: Colors.green, fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //       if (type == ListTypes.requests)
  //         ListTile(
  //           leading: const Icon(
  //             Icons.clear,
  //             color: Colors.red,
  //           ),
  //           title: Label(
  //             text: 'Reject ${user.name} Friend Request',
  //             style: Styles.mediumText(
  //                 color: Colors.red, fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //       if (type == ListTypes.friends)
  //         ListTile(
  //           leading: const Icon(
  //             Icons.block_flipped,
  //             color: Colors.red,
  //           ),
  //           title: Label(
  //             text: 'Unfriend ${user.name}',
  //             style: Styles.mediumText(
  //                 color: Colors.red, fontWeight: FontWeight.w600),
  //           ),
  //           subtitle: Label(
  //             text: 'You can remove ${user.name} from friends list',
  //           ),
  //         ),
  //     ],
  //   );
  // }
}
