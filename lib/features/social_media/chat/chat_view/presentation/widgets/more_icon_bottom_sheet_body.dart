import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MoreIconBottomSheet extends StatelessWidget {
  final ChatItemModel chatItemModel;
  final ChatsCubit chatsCubit;

  const MoreIconBottomSheet({super.key, required this.chatItemModel, required this.chatsCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomSheetItem(
            context: context,
            title: chatItemModel.muted! ? 'Unmute' : 'Mute',
            icon: chatItemModel.muted! ? Icons.volume_down : Icons.volume_off,
            function: () {
              chatsCubit.changeChatMuteState(chatItemModel.sId!);
            },
          ),
          bottomSheetItem(
            context: context,
            title: chatItemModel.locked! ? "Unlock chat": "Lock chat" ,
            icon: Icons.lock,
            function: () {
              if(chatItemModel.locked!){
                chatsCubit.unLockChat(chatItemModel.sId!);
              }else{
                chatsCubit.lockChat(chatItemModel.sId!);
              }
            },
          ),
          bottomSheetItem(
            context: context,
            title: "Delete chat",
            icon: Icons.delete,
            function: () async {
              bool confirmDeleted = false;
              confirmDeleted = await showDialogConfirmDeleted(context);
            },
          ),
        ],
      ),
    );
  }

  Widget bottomSheetItem({
    required String title,
    required IconData icon,
    bool withUnderLine = true,
    required Function() function,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        function();
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: title,
                  style: Styles.headerText(),
                ),
                Icon(
                  icon,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            if (withUnderLine)
              const Divider(
                height: 1,
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> showDialogConfirmDeleted(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove this chat'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'))
            ],
          )),
    );
  }
}
