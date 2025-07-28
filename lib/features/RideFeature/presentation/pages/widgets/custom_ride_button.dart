
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/constants/registration_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';


import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';


class CustomRideButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isRed;
  final bool isPending;
  final String status;
  final GestureTapCallback? onTap;

  const CustomRideButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.isRed = false,
    this.isPending = false, this.status = 'pending', this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isRed
                          ? [
                        AppColors.cF33D49,
                        AppColors.cC0303A,
                        AppColors.cA72A32,
                        AppColors.c9A272E,
                        AppColors.c93252C,
                        AppColors.c90242B,
                      ]
                          : [
                        AppColors.c0B1035,
                        AppColors.c161F68,
                        AppColors.c1B2781,
                        AppColors.c1E2B8E,
                        AppColors.c1F2D95,
                        AppColors.c0B1035,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                if (isDisabled)
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                Positioned.fill(
                  child: ElevatedButton(
                    onPressed: isDisabled ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      text,
                      style: Styles.headerText(
                        color: isDisabled ? Colors.grey[400] : Colors.white,
                        shadows: isDisabled
                            ? [
                          const Shadow(
                            color: Color(0xFFFFFFFF),
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                          const Shadow(
                            color: Color(0xFFD9D9D9),
                            offset: Offset(1, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFFFFFFFF),
                            offset: Offset(0, 0),
                            blurRadius: 4,
                          ),
                          const Shadow(
                            color: Color(0xFFD9D9D9),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFF3C3C43),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFF818181),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                        ] :  [
                          const Shadow(
                            color: Color(0xFFFFFFFF),
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                          const Shadow(
                            color: Color(0xFFD9D9D9),
                            offset: Offset(1, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFFFFFFFF),
                            offset: Offset(0, 0),
                            blurRadius: 4,
                          ),
                          const Shadow(
                            color: Color(0xFFD9D9D9),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFF3C3C43),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                          const Shadow(
                            color: Color(0xFF818181),
                            offset: Offset(0, 0),
                            blurRadius: 4,

                          ),
                        ],
                      ),
                      // style: TextStyle(
                      //   fontSize: 40.sp,
                      //   fontWeight: FontWeight.w600,
                      //   color: isDisabled ? Colors.grey[400] : Colors.white,
                      //   shadows: isDisabled
                      //       ? [
                      //     const Shadow(
                      //       color: Color(0xFFFFFFFF),
                      //       offset: Offset(0, 1),
                      //       blurRadius: 4,
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFD9D9D9),
                      //       offset: Offset(1, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFFFFFFF),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFD9D9D9),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFF3C3C43),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFF818181),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //   ] :  [
                      //     const Shadow(
                      //       color: Color(0xFFFFFFFF),
                      //       offset: Offset(0, 1),
                      //       blurRadius: 4,
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFD9D9D9),
                      //       offset: Offset(1, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFFFFFFF),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFFD9D9D9),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFF3C3C43),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //     const Shadow(
                      //       color: Color(0xFF818181),
                      //       offset: Offset(0, 0),
                      //       blurRadius: 4,
                      //
                      //     ),
                      //   ],
                      // ),
                      // textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Sizer(),
          Text(
            status==RegistrationStatus.rejected.status?context.isArabic?"مرفوض":"Rejected"
                :status==RegistrationStatus.pending.status?context.isArabic?'انتظار الموافقة':"Waiting approval"
                :status==RegistrationStatus.initial.status?context.isArabic?'غير مكتمل':"Pending":'',
            style: const TextStyle(color: Colors.red),)
        ],
      ),
    );
  }
}



