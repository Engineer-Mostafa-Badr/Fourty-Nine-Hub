import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import 'cards/trip_contacts_buttons.dart';
import 'trip_join_card_button.dart';
import '../../../../../../res/style/app_colors.dart';

class TripJoinButtonsSection extends StatelessWidget {
  const TripJoinButtonsSection({
    super.key,
    required this.isContactInfo,
    this.buttonTitle,
    required this.isRequestButton,
    required this.onTap,
  });

  final bool isContactInfo;
  final bool isRequestButton;
  final String? buttonTitle;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isRequestButton
            ? Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  child: TripJoinCardButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    title: buttonTitle ?? '',
                    color: AppColors.getRedColor(context),
                    onTap: onTap,
                    radius: 15,
                  ),
                ),
              )
            : Container(),
        isContactInfo && isRequestButton
            ? const Sizer(
                width: 60,
              )
            : Container(),
        isContactInfo
            ? const Expanded(
                child: ContactsTripButtons(
                  otherUserId: '2',
                  subcategoryId: '2',
                  phone: '2223',
                  id: '2',
                  hasReport: true,
                ),
              )
            : Container(),
      ],
    );
  }
}
