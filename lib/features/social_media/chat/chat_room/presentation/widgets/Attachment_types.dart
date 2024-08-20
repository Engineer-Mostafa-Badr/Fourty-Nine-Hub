import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/picker/cam_picker.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
          label: 'Document',
          icon: Icons.insert_drive_file_outlined,
          onTap: () {
            chatRoomCubit.pickDocuments();
          },
        ),
        _buildAttachmentTypeItem(
          color: Colors.redAccent,
          label: 'Camera',
          icon: Icons.camera_alt,
          onTap: () {
            showDialog(
                context: context, builder: (context) => const CameraPicker());
          },
        ),
        _buildAttachmentTypeItem(
            color: Colors.purpleAccent,
            label: 'Gallery',
            icon: Icons.image_outlined),
        _buildAttachmentTypeItem(
            color: Colors.orange[600]!,
            label: 'Audio',
            icon: Icons.headphones_rounded),
        _buildAttachmentTypeItem(
            color: Colors.green,
            label: 'Location',
            icon: Icons.location_on_rounded),
        _buildAttachmentTypeItem(
            color: Colors.lightBlue, label: 'Contact', icon: Icons.person),
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
