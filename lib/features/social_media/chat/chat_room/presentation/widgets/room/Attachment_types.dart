import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AttachmentTypes extends StatelessWidget {
  const AttachmentTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        _buildAttachmentTypeItem(
            color: Colors.purple, label: 'Document', icon: Icons.file_copy),
        _buildAttachmentTypeItem(
            color: Colors.redAccent, label: 'Camera', icon: Icons.camera_alt),
        _buildAttachmentTypeItem(
            color: Colors.purpleAccent, label: 'Gallery', icon: Icons.image),
        _buildAttachmentTypeItem(
            color: Colors.orange,
            label: 'Audio',
            icon: Icons.audio_file_outlined),
        _buildAttachmentTypeItem(
            color: Colors.greenAccent,
            label: 'Location',
            icon: Icons.location_on_rounded),
        _buildAttachmentTypeItem(
            color: Colors.blue, label: 'Contact', icon: Icons.person),
      ],
    );
  }

  Widget _buildAttachmentTypeItem(
      {required Color color, required String label, required IconData icon}) {
    return Column(
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
    );
  }
}
