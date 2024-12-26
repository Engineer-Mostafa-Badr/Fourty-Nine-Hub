import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_type_card.dart';

class HealthBookingTypesWidgt extends StatelessWidget {
  const HealthBookingTypesWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    final services = context.read<HealthCubit>().services;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2,
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 50,
      ),
      itemBuilder: (context, index) => HealthBookingTypeCard(
        bookingFilterModel: services[index],
      ),
    );
  }
}
