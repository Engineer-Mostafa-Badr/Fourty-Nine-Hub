import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/style/app_colors.dart';

class ListsView extends StatelessWidget {
  const ListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(label: 'Lists'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: listItem(icon: Icons.block, selected: true)),
                Expanded(child: listItem(icon: Icons.person_add)),
                Expanded(child: listItem(icon: Icons.person)),
                Expanded(child: listItem(icon: Icons.group)),
              ],
            ),
          ),
          Label(text: 'Continue...'),
        ],
      ),
    );
  }

  Widget listItem({
    required IconData icon,
    bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: selected ? AppColors.PRIMARY_COLOR : null,
      ),
      child: Icon(
        icon,
        color: selected ? Colors.white : null,
      ),
    );
  }
}
