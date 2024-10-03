import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';

class DoctorDetailsAddressCard extends StatelessWidget {
  const DoctorDetailsAddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.doctor;
    if (doctor.address.address.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Column(
        children: [
          DoctorDetailsInfoCard(
            icon: Icons.location_on_outlined,
            label: doctor.address.address,
          ),
          const DoctorDetailsDivider(),
        ],
      );
    }
  }
}
