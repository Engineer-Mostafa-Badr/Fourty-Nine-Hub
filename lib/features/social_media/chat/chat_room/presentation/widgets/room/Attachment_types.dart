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
            color: Colors.purple,
            label: 'Document',
            icon: Icons.insert_drive_file_outlined),
        _buildAttachmentTypeItem(
            color: Colors.redAccent, label: 'Camera', icon: Icons.camera_alt),
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
