import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DeleteMessageBody extends StatelessWidget {
  const DeleteMessageBody({super.key});

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
            color: AppColors.GREY_LIGHT_COLOR
          ),
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:  Column(
              children: [
                Label(
                  text: 'Delete for everyone',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w600, color: Colors.black,fontSize: 14),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Divider(),
                ),
                Label(
                  text: 'Delete for me',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w600, color: Colors.black,fontSize: 14),
                ),



              ],
            ),
          ),
        ),

        const SizedBox(height: 10,),
      ],
    );
  }
}
