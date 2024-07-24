import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_service_card.dart';

class HealthMedicalServices extends StatelessWidget {
  const HealthMedicalServices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
      if (state.medicalServices != null && state.medicalServices!.isNotEmpty) {
        return SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Sizer(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => HealthMedicalServiceCard(
                subCategory: state.medicalServices![index]),
            // Text("fsa"),
            itemCount: state.medicalServices!.length,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
