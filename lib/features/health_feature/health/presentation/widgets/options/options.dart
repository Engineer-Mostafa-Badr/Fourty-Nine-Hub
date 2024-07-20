import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/options/option_card.dart';

class HealthOptions extends StatelessWidget {
  const HealthOptions({super.key});

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
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => HealthOptionCard(
        imagePath: services[index].image,
        name: services[index].name,
      ),
    );
  }
}
