// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/camera_picker/camera_picker.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AttachmentTypes extends StatelessWidget {
  final ChatRoomCubit chatRoomCubit;

  const AttachmentTypes({super.key, required this.chatRoomCubit});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        _buildAttachmentTypeItem(
          color: Colors.purple,
          label: LocaleKeys.document.tr(),
          icon: Icons.insert_drive_file_outlined,
          onTap: () async {
            await chatRoomCubit.pickDocuments();
            if(chatRoomCubit.media.isNotEmpty){
              List<File> tempMedia = [...chatRoomCubit.media]; // spread operator
              chatRoomCubit.media.clear();
              for (var media in tempMedia) {
                chatRoomCubit.media.add(media);
                await chatRoomCubit.sendMessage();
                chatRoomCubit.media.clear();
              }

            }
            context.pop();
          },
        ),
        _buildAttachmentTypeItem(
          color: Colors.redAccent,
          label: LocaleKeys.camera.tr(),
          icon: Icons.camera_alt,
          onTap: () async {
            context.push(Routes.CHATROOMCAMERAPICKER);
          },
        ),
        _buildAttachmentTypeItem(
            color: Colors.purpleAccent,
            label: LocaleKeys.gallery.tr(),
            onTap: () async {
              await chatRoomCubit.pickMedia();
              context.push(
                Routes.MEDIASLIDER,
                extra: chatRoomCubit,
              );
              context.pop();
            },
            icon: Icons.image_outlined),
        _buildAttachmentTypeItem(
            color: Colors.orange[600]!,
            label: LocaleKeys.audio.tr(),
            onTap: () => chatRoomCubit.pickAudio(),
            icon: Icons.headphones_rounded),
        _buildAttachmentTypeItem(
            color: Colors.green,
            label: LocaleKeys.location.tr(),
            icon: Icons.location_on_rounded),
        _buildAttachmentTypeItem(
            color: Colors.lightBlue,
            label: LocaleKeys.contact.tr(),
            icon: Icons.person,
            onTap: () {
              context.push(Routes.SELECTCONTACTSTOSHARE,
                extra: chatRoomCubit,
              );
            }),
      ],
    );
  }

  Widget _buildAttachmentTypeItem(
      {required Color color,
      required String label,
      required IconData icon,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Label(text: label, style: Styles.mediumText())
        ],
      ),
    );
  }
}
