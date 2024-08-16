import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MoreIconBottomSheet extends StatefulWidget {
  final ChatModel chatItemModel;
  final ChatsCubit chatsCubit;

  const MoreIconBottomSheet(
      {super.key, required this.chatItemModel, required this.chatsCubit});

  @override
  State<MoreIconBottomSheet> createState() => _MoreIconBottomSheetState();
}

class _MoreIconBottomSheetState extends State<MoreIconBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              widget.chatsCubit.changeChatMuteState(widget.chatItemModel.sId!);
            },
            child: bottomSheetItem(
              context: context,
              title: widget.chatItemModel.muted! ? 'Unmute' : 'Mute',
              icon: widget.chatItemModel.muted!
                  ? Icons.volume_down
                  : Icons.volume_off,
            ),
          ),
          GestureDetector(
            onTap: () async {
              showDialogToCreateLockChatPassword(context);
            },
            child: bottomSheetItem(
              context: context,
              title: widget.chatItemModel.locked! ? "Unlock chat" : "Lock chat",
              icon: Icons.lock,
            ),
          ),
          GestureDetector(
            onTap: () async {
              bool confirmDeleted =
                  await showDialogConfirmDeleted(context) ?? false;
              if (confirmDeleted) {
                // handle deleted useCase here
              }
            },
            child: bottomSheetItem(
              context: context,
              title: "Delete chat",
              icon: Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheetItem({
    required String title,
    required IconData icon,
    bool withUnderLine = true,
    required BuildContext context,
  }) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
    );
  }

  Future<bool?> showDialogConfirmDeleted(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: ((context) => CupertinoAlertDialog(
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

  Future<bool?> showDialogToCreateLockChatPassword(BuildContext context) async {
    TextEditingController passwordController = TextEditingController(text: '');
    return await showDialog(

      context: context,
      builder: ((context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Label(
                text: 'Lock chats password please',
                style: Styles.headerText(
                    fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            content: Material(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormTextField(
                        controller: passwordController,
                        hint: 'password',
                        type: TextInputType.number,
                        // initialValue: '',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold),
                        action: (v) => () {}),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (widget.chatItemModel.locked!) {
                      await widget.chatsCubit.unLockChat(
                          chatId: widget.chatItemModel.sId!,
                          lockChatPassword: passwordController.text.trim());
                    } else {
                      await widget.chatsCubit.lockChat(
                          chatId: widget.chatItemModel.sId!,
                          lockChatPassword: passwordController.text.trim());
                    }

                    Navigator.of(context).pop(false);
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Confirm password')),
            ],
          )),
    );
  }
}
