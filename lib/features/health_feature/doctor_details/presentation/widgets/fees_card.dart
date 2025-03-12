import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';

class DoctorDetailsFeesCard extends StatelessWidget {
  const DoctorDetailsFeesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.state.doctor;
    return Column(
      children: [
        if (doctor?.clinicPrice.isNotEmpty??false)
          DoctorDetailsInfoCard(
              icon: Icons.wallet_rounded,
              label:
                  '${LocaleKeys.clinicFees.localize}: ${doctor?.clinicPrice??0} ${context.isArabic ? doctor?.currencyAr??'' : doctor?.currencyEn??''}'),
        if (doctor?.callsPrice.isNotEmpty??false)
          DoctorDetailsInfoCard(
              icon: Icons.wallet_rounded,
              label:
                  '${LocaleKeys.callFees.localize}: ${doctor?.callsPrice??0} ${context.isArabic ? doctor?.currencyAr??'' : doctor?.currencyEn??''}'),
        if (doctor?.visitHomePrice.isNotEmpty??false)
          DoctorDetailsInfoCard(
              icon: Icons.wallet_rounded,
              label:
                  '${LocaleKeys.homeVisitFees.localize}: ${doctor?.visitHomePrice??0} ${context.isArabic ? doctor?.currencyAr??'' : doctor?.currencyEn??''}'),
        const DoctorDetailsDivider(),
      ],
    );
  }
}
