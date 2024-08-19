import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DeleteMessageBody extends StatelessWidget {
  final VoidCallback? deleteMessageFunction;
  const DeleteMessageBody({super.key, this.deleteMessageFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Label(
          text: 'Delete message?',
          style: Styles.headerText(
              fontWeight: FontWeight.bold, color: Colors.black),
        )),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.GREY_LIGHT_COLOR),
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: deleteMessageFunction,
                      child: Label(
                        text: 'Delete message',
                        style: Styles.mediumText(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 5),
                //   child: Divider(),
                // ),
                // Label(
                //   text: 'Delete for me',
                //   style: Styles.mediumText(
                //       fontWeight: FontWeight.w600, color: Colors.red,fontSize: 15),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
