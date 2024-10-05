import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_ditails_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/image_card_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/not_subscribed_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/slider_card_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ChanceCardWidget extends StatelessWidget {
  const ChanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChanceDitailsWidget())) ;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppColors.SHADOW_LIGHT,
        ),
        child: Row(
          children: [
            const ImageCardWidget(),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قسيمة تسوق ب 200 جنيه',
                    style:Styles.mediumText(
                      fontSize: 60.sp
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
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const NotSubscribedWidget(),
                  const SizedBox(height: 10),
                  const SliderCardWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// 'assets/images/doctor.png'
