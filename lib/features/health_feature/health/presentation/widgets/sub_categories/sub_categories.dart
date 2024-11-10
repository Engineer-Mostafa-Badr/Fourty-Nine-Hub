import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class HealthSubCategories extends StatelessWidget {
  const HealthSubCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.subCategories==null?
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Label(
                  text: LocaleKeys.specialities.localize,
                  style: Styles.headerText(),
                ),
              ) :state.subCategories==[]?
              const SizedBox.shrink():Label(
                text: LocaleKeys.medicalService.localize,
                style: Styles.headerText(),
              ),
              const Sizer(),
              Expanded(
                child: (state.subCategories!=null&&state.subCategories!=[])?ListView.separated(
                  separatorBuilder: (context, index) => const Sizer(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => HealthSubCategoryCard(
                      subCategory: state.subCategories![index]),
                  itemCount: state.subCategories?.length??0,
                ):state.subCategories==null?Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Sizer(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    itemCount: 3,
                  ),
                ):const SizedBox.shrink(),
              ),
            ],
          ),
        );

    });
  }
}
