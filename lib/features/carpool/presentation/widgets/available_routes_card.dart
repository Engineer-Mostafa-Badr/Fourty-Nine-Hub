import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/carpool/presentation/widgets/address_info_list.dart';
import 'package:fourtyninehub/features/carpool/presentation/widgets/available_rotes_bar_info.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvaiableRoutesCard extends StatelessWidget {
  const AvaiableRoutesCard({
    super.key,
    required this.entity,
  });

  final AvailableRoutesCardEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: CustomCard(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("40:00:00", style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${entity.price} EGP', style: Styles.headerText(color: AppColors.CHECK_MARK_COLOR)),
                  Text("per seat", style: Styles.mediumText()),
                ],
              ),
            ],
          ),
          AvilableRoutesBarInfo(entity: entity),
          const Sizer(),
          AddressInfoList(entity: entity),
          const Sizer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("20 Minutes ago", style: Styles.mediumText()),
              const Spacer(),
              Text(entity.onlyWomanAllowed == true ? 'Womens Only' : '',
                  style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
            ],
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
