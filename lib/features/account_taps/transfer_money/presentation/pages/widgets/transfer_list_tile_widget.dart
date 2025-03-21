import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/styles.dart';

class TransferListTileWidget extends StatelessWidget {
  const TransferListTileWidget({
    super.key,
    required this.title,
    required this.mail,
    required this.name,
    required this.image,
  });

  final String title;
  final String mail;
  final String name;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFB4B4B4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: image,
      ),
      title: Label(
        text: title,
        style: Styles.mediumText(
          fontWeight: FontWeight.w500,
          fontSize: 32,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: mail,
            style: Styles.mediumText(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          Label(
            text: name,
            style: Styles.mediumText(
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
