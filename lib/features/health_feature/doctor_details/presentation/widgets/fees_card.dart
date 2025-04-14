import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/style/styles.dart';

class DoctorDetailsCard extends StatelessWidget {

  const DoctorDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.state.doctor;
    return Column(
      children: [
        if (doctor?.callsPrice.isNotEmpty ?? false)
          Container(
            width: 690.w,
            height: 52.h,
            child: Row(
              children: [
                Text(
                  '${LocaleKeys.callFees.localize}: ',
                  style: Styles.mediumText(),
                ),
                const Spacer(),
                Text(
                  '${doctor?.callsPrice ?? 0} ${context.isArabic ? doctor?.currencyAr ?? '' : doctor?.currencyEn ?? ''}',
                  style: Styles.mediumText(),
                ),
              ],
            ),
          ),
        const Sizer(),
        DoctorDetailsInfoCard(
            icon: Icons.access_time,
            label:
                '${LocaleKeys.waitingTime.localize}: ${doctorDetailsCubit.state.doctor?.waitingTime ?? ''} ${LocaleKeys.minuteLoc.localize}'),
        const Sizer(),
        doctorDetailsCubit.state.doctor?.address != null
            ? DoctorDetailsInfoCard(
                icon: Icons.location_on,
                color: AppColors.PRIMARY_COLOR,
                label: doctor?.description.length.toString() ?? '',
              )
            : SizedBox(),
      const Sizer()
      ],
    );
  }
}
