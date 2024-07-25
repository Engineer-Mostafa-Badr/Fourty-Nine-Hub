import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';

class HealthSubCategories extends StatelessWidget {
  const HealthSubCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
      if (state.subCategories != null && state.subCategories!.isNotEmpty) {
        return SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Sizer(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                HealthSubCategoryCard(subCategory: state.subCategories![index]),
            itemCount: state.subCategories!.length,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
