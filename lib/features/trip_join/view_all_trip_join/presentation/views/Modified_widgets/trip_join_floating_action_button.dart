import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../res/style/app_colors.dart';

import '../../../../../../helpers/manage_vibration.dart';
import '../../../../../../helpers/manage_vibration.dart';

class TripJoinFloatingActionButton extends StatelessWidget {
  const TripJoinFloatingActionButton({
    super.key, required this.onTap, required this.title,
  });
  final void Function() onTap;
  final String title;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RawMaterialButton(
            onPressed:(){
              ManageVibration.vibrate();
              onTap.call();
            },
            fillColor:context.isDarkMode?AppColors.Floating_Button_COLOR_DARK: AppColors.PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4.0,
            child: Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: 32.h,vertical: 16.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color:context.isDarkMode?AppColors.black: Colors.white, size: 20),
                  const SizedBox(),
                  Text(title,
                    style: TextStyle(
                      color: context.isDarkMode?AppColors.black:Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}