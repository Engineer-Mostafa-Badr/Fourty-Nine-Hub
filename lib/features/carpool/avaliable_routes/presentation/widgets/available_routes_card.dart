import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/address_info_list.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_rotes_bar_info.dart';
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
              // Text("40:00:00",
              //     style: Styles.smallText(
              //         color: AppColors.SECONDARY_COLOR,
              //         fontWeight: FontWeight.w600)),
              // SizedBox(
              //   width: 24,
              // ),
              Text(LocaleKeys.comfort.localize,
                  style: Styles.mediumText(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('${entity.price} ',
                          style: Styles.headerText(
                              fontSize: 36,
                              color: AppColors.CHECK_MARK_COLOR,
                              fontWeight: FontWeight.w600)),
                      Text(LocaleKeys.egp.localize,
                          style: Styles.headerText(
                            fontSize: 22,
                            color: AppColors.SECONDARY_COLOR,
                          )),
                    ],
                  ),
                  Text(LocaleKeys.seat.localize,
                      style: Styles.mediumText(
                        color: AppColors.PRIMARY_COLOR,
                      )),
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
              Text(LocaleKeys.minutesAgo.localize,
                  style: Styles.headerText(fontSize: 24)),
              const Spacer(),
              Text(
                  entity.onlyWomanAllowed == true
                      ? LocaleKeys.womenOnly.localize
                      : '',
                  style: Styles.headerText(
                      fontSize: 24, color: AppColors.SECONDARY_COLOR)),
            ],
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
