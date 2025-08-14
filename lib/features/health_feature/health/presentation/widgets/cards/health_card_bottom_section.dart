import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_contacts_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class HealthCardButtonsSection extends StatelessWidget {
  const HealthCardButtonsSection({
    super.key,
    this.buttonTitle,
    required this.isSubscribed, required this.onTap, required this.isButton,
  });
  final bool isSubscribed;
  final bool isButton;
  final String? buttonTitle;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(isButton)
          Expanded(
          child: Padding(
            padding: EdgeInsets.only(top:8.h,bottom: 8.h),
            child: TripJoinCardButton(
              padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              title: buttonTitle??'',
              color:isSubscribed? AppColors.SECONDARY_COLOR:AppColors.SECONDARY_COLOR.withOpacity(0.4),
              onTap:isSubscribed? onTap:(){

      ManageVibration.vibrate();
              },
              radius: 15,
            ),
          ),
        ),
        if(isButton)
          const Sizer(
          width: 60,
        ),
        const Expanded(
          child:  HealthContactsButtons(
            // otherUserId: widget.tripJoinCardEntity.userId!,
            // subcategoryId: widget.tripJoinCardEntity.categoryId!,
            // phone: widget.tripJoinCardEntity.phone!,
            // id: widget.tripJoinCardEntity.id!,
            // hasReport: true,
            otherUserId: '2',
            subcategoryId: '2',
            phone: '2223',
            id: '2',
            hasReport: true,
          ),
        ),
      ],
    );
  }
}