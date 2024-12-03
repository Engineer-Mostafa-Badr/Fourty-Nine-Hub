import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/info.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class DoctorDetailsWaitingTimeCard extends StatelessWidget {
  const DoctorDetailsWaitingTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    if (doctorDetailsCubit.doctor.waitingTime.isNotEmpty) {
      return Column(
        children: [
          DoctorDetailsInfoCard(
              icon: Icons.access_time,
              label:
                  '${LocaleKeys.waitingTime.localize}: ${doctorDetailsCubit.doctor.waitingTime} ${LocaleKeys.minuteLoc.localize}'),
          const DoctorDetailsDivider(),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
