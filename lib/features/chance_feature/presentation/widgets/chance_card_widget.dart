import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/not_subscribed_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../res/style/app_colors.dart';

class ChanceCardWidget extends StatelessWidget {
  const ChanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.SHADOW,
      ),
      child: Row(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قسيمة تسوق ب 200 جنيه',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '200 ج.م',
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const NotSubscribedWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// 'assets/images/doctor.png'
