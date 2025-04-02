import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

Future<dynamic> JoinTripBottomSheet(context,{required Color topButtonColor,required Color bottomButtonColor,required String topButtonTitle,required String bottomButtonTitle}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.whiteColor,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    isScrollControlled: true,
    builder: (context)=>Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: AppColors.whiteColor,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned(
                top: 10,
                right:12,
                child: GestureDetector(
                  onTap:()=> Navigator.of(context).pop(),
                  child: CircleAvatar(
                    radius: 24.h,
                    backgroundColor: AppColors.BG_GRAY_COLOR,
                    child:Icon(Icons.close) ,
                  ),
                )),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 45, 12, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){ Navigator.of(context).pop();},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: topButtonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.h,
                          vertical: 12.h,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            topButtonTitle,
                            style: Styles.headerText(),
                          ),
                        ),
                      ),
                    ),
                    const Sizer(),
                    ElevatedButton(
                      onPressed: (){ Navigator.of(context).pop();},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:bottomButtonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.h,
                          vertical: 12.h,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            bottomButtonTitle,
                            style: Styles.headerText( color: bottomButtonColor==AppColors.BG_GRAY_COLOR?Colors.black:Colors.white),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}