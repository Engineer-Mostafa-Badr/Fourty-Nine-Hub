import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/widgets/select_main_category.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/widgets/select_sub_category.dart';

import '../../domain/entities/categorization_entity.dart';
import '../widgets/enter_ad_details.dart';

class CreateAdView extends StatelessWidget {
 final  CategorizationEntity categorization;
  const CreateAdView({super.key, required this.categorization});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateAdCubit>();
    return BlocBuilder<CreateAdCubit, CreateAdState>(builder: (context, state) {
      return const EnterAdDetails();
      // if (state.selectedCategory == null &&
      //     (state.mainCategories?.isNotEmpty ?? false)) {
      //   return SelectMainCategory(
      //     mainCategories: state.mainCategories ?? [],
      //     onSelected: (category) => controller.onMainCategorySelected(
      //         category: category, context: context),
      //   );
      // } else if (state.selectedSubCategory == null &&
      //     (state.subCategories?.isNotEmpty ?? false)) {
      //   return SelectSubCategory(
      //       subCategories: state.subCategories ?? [],
      //       onSelected: (category) =>
      //           controller.onSubCategorySelected(category: category));
      // } else if (state.selectedCategory != null &&
      //     state.selectedSubCategory != null) {
      //   return const EnterAdDetails();
      // }

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    });
  }
}
