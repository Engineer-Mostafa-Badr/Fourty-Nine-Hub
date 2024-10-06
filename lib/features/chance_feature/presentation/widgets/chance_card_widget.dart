import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/pages/chance_details_view.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/image_card_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/subscribe_widget_in_card.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/slider_card_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class ChanceCardWidget extends StatelessWidget {
  const ChanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>  ChanceDetailsView())) ;
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
                    '200 EGP shopping voucher',
                    style:Styles.mediumText(
                      fontSize: 50.sp
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '200',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.QUANTITY_COLOR,
                        ),
                      ),
                      Text(
                        'EGP',
                        style: TextStyle(
                          fontSize:25.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const NotSubscribedWidget(),
                  const SizedBox(height: 3),
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
