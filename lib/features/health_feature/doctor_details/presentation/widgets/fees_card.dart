import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class DoctorDetailsFeesCard extends StatelessWidget {
  const DoctorDetailsFeesCard({super.key, });

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.doctor;
    return DoctorDetailsInfoCard(
        icon: Icons.wallet_rounded,
        label:
            '${Labels.startPrice}: ${doctor.priceToShow} ${Labels.currency}');
  }
}
