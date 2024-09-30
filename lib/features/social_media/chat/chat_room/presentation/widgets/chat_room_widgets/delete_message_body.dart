import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          margin: EdgeInsets.symmetric(vertical: 15.h),
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
                            fontSize: 15.sp),
                      ),
                    ),
                  ],
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 5.h),
                //   child: Divider(),
                // ),
                // Label(
                //   text: 'Delete for me',
                //   style: Styles.mediumText(
                //       fontWeight: FontWeight.w600, color: Colors.red,fontSize: 15.sp),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
