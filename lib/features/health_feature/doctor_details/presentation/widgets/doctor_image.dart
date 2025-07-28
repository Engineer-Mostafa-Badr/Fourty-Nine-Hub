import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class DoctorImage extends StatelessWidget {
  final String imageUrl;
  final num rating;

  const DoctorImage({super.key, required this.imageUrl, required this.rating});

  @override
  Widget build(BuildContext context) {
    return   Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        SquareImage(
          source: NetworkImage(
         imageUrl,
          ),
          radius: 15,
          height: 112.h,
          width: 125.w,
        ),
        Container(
          width: 64.w,
          height: 32.h,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15.r)
          ),
          child: Row(
            children: [
              Icon(Icons.star,size: 20.sp,color: AppColors.ACCENT_COLOR,),
              Text(rating.toDouble().toString(),style: Styles.mediumText(color: AppColors.black),),
            ],
          ),
        ),

      ],
    );
  }
}
