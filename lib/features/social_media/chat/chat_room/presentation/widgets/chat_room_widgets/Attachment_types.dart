// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/camera_picker/camera_picker.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AttachmentTypes extends StatefulWidget {
  final ChatRoomCubit chatRoomCubit;

  const AttachmentTypes({super.key, required this.chatRoomCubit});

  @override
  State<AttachmentTypes> createState() => _AttachmentTypesState();
}

class _AttachmentTypesState extends State<AttachmentTypes> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ?  const Center(child: CircularProgressIndicator(color: AppColors.PRIMARY_COLOR,))
        : GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            children: [
              _buildAttachmentTypeItem(
                color: Colors.purple,
                label: LocaleKeys.document.tr(),
                icon: Icons.insert_drive_file_outlined,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await widget.chatRoomCubit.pickDocuments();
                  if (widget.chatRoomCubit.media.isNotEmpty) {
                    List<File> tempMedia = [
                      ...widget.chatRoomCubit.media
                    ]; // spread operator
                    widget.chatRoomCubit.media.clear();
                    for (var media in tempMedia) {
                      widget.chatRoomCubit.media.add(media);
                      await widget.chatRoomCubit.sendMessage();
                      widget.chatRoomCubit.media.clear();
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                  context.pop();
                },
              ),
              _buildAttachmentTypeItem(
                color: Colors.redAccent,
                label: LocaleKeys.camera.tr(),
                icon: Icons.camera_alt,
                onTap: () async {
                  context.push(Routes.CHATROOMCAMERAPICKER,
                      extra: CameraPickerViewPrams(
                        chatRoomCubit: widget.chatRoomCubit,
                      ));
                },
              ),
              _buildAttachmentTypeItem(
                  color: Colors.purpleAccent,
                  label: LocaleKeys.gallery.tr(),
                  onTap: () async {
                    await widget.chatRoomCubit.pickMedia();
                    context.push(
                      Routes.MEDIASLIDER,
                      extra: widget.chatRoomCubit,
                    );
                    context.pop();
                  },
                  icon: Icons.image_outlined),
              _buildAttachmentTypeItem(
                  color: Colors.orange[600]!,
                  label: LocaleKeys.audio.tr(),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.chatRoomCubit.pickAudio();
                    if (widget.chatRoomCubit.media.isNotEmpty) {
                      List<File> tempMedia = [
                        ...widget.chatRoomCubit.media
                      ]; // spread operator
                      widget.chatRoomCubit.media.clear();
                      for (var media in tempMedia) {
                        widget.chatRoomCubit.media.add(media);
                        await widget.chatRoomCubit.sendMessage();
                        widget.chatRoomCubit.media.clear();
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                    context.pop();
                  },
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
                    context.push(
                      Routes.SELECTCONTACTSTOSHARE,
                      extra: widget.chatRoomCubit,
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
