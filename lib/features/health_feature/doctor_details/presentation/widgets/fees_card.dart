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
import '../../../health/domain/entities/appointment_booking_entity.dart';

class DoctorDetailsCard extends StatelessWidget {
  final String type;

  const DoctorDetailsCard({
    super.key, required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.state.doctor;

    // final doctor = context.read<BookDoctorAppointmentCubit>().doctor;


    return Column(
      children: [
        type == BookingTypes.call.name? SizedBox(
            width: 690.w,
            height: 52.h,
            child: Row(
              children: [
                Text(
                  '${LocaleKeys.call.localize}: ',
                  style: Styles.mediumText(),
                ),
                const Spacer(),
                Text(
                  '${doctor?.priceToShow ?? 0} ${context.isArabic ? doctor?.currencyAr ?? '' : doctor?.currencyEn ?? ''}',
                  style: Styles.mediumText(),
                ),
              ],
            ),
          ):type == BookingTypes.clinic.name?   SizedBox(
            width: 690.w,
            height: 52.h,
            child: Row(
              children: [
                Text(
                  '${LocaleKeys.clinicFees.localize}: ',
                  style: Styles.mediumText(),
                ),
                const Spacer(),
                Text(
                  '${doctor?.priceToShow ?? 0} ${context.isArabic ? doctor?.currencyAr ?? '' : doctor?.currencyEn ?? ''}',
                  style: Styles.mediumText(),
                ),
              ],
            ),
          ):type == BookingTypes.home.name?   SizedBox(
          width: 690.w,
          height: 52.h,
          child: Row(
            children: [
              Text(
                '${LocaleKeys.homeVisitFees.localize}: ',
                style: Styles.mediumText(),
              ),
              const Spacer(),
              Text(
                '${doctor?.priceToShow ?? 0} ${context.isArabic ? doctor?.currencyAr ?? '' : doctor?.currencyEn ?? ''}',
                style: Styles.mediumText(),
              ),
            ],
          ),
        ):SizedBox(),

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
