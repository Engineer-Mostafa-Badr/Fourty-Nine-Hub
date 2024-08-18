import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text:LocaleKeys.specialities.localize,
                style: Styles.headerText(),
              ),
              const Sizer(),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Sizer(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => HealthSubCategoryCard(
                      subCategory: state.subCategories![index]),
                  itemCount: state.subCategories!.length,
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
