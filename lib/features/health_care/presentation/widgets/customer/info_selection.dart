import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

class InfoSelection extends StatelessWidget {
  final String title;
  final List<dynamic> options;
  final Function(dynamic) onOptionSelected;
  const InfoSelection(
      {super.key,
      required this.title,
      required this.options,
      required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: title,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final option = options[index];
            return ListTile(
              onTap: () => onOptionSelected(option),
              title: option.name != null
                  ? Label(text: option.name, style: Styles.mediumText())
                  : null,
              leading: option.image != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(option.image),
                    )
                  : null,
              trailing: const Icon(Icons.keyboard_arrow_right),
            );
          },
          separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
          itemCount: options.length),
    );
  }
}
