import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../add_new_trip_join/presentation/views/widgets/card.dart';
import '../../domain/entities/tripjoin_request_history_entity.dart';
import '../../../view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TripJoinRequestHistoryCard extends StatelessWidget {
  const TripJoinRequestHistoryCard({
    super.key,
    required this.tripJoinRequestHistoryEntity,
    this.callOnTap,
    this.messageOnTap,
    this.reportOnTap,
  });
  final TripJoinRequestHistoryEntity tripJoinRequestHistoryEntity;
  final void Function()? callOnTap;
  final void Function()? messageOnTap;
  final void Function()? reportOnTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: CustomCard(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300]!, offset: const Offset(3, 3)),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  tripJoinRequestHistoryEntity.gender == 'female'
                      ? Assets.femaleImagePlacehlder
                      : Assets.maleImagePlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
              Sizer(width: 30.w),
              Text(tripJoinRequestHistoryEntity.firstName ?? 'Unknown',
                  style: Styles.headerText()),
            ],
          ),
          const Sizer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.call.localize,
                  color: (tripJoinRequestHistoryEntity.allowStatus == 'enable')
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.call,
                  onTap: callOnTap,
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.message.localize,
                  color: (tripJoinRequestHistoryEntity.allowStatus == 'enable')
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                  icon: Icons.email,
                  onTap: messageOnTap,
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 3,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.report.localize,
                  color: AppColors.getSecondryColor(context),
                  icon: Icons.report,
                  onTap: reportOnTap,
                ),
              ),
            ],
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
