import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NotSubscribedWidget extends StatelessWidget {
  const NotSubscribedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.red,
              spreadRadius: 0.03,
              blurRadius: 1,
            )
          ]
      ),
      child: Row(
        children: [
          Text(
            'غير مشترك',
            style: Styles.headerText()
          ),
          const Spacer(),
          const Icon(Icons.remove_circle, color: Colors.red),

        ],
      ),
    );
  }
}
