import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class HealthEmergencySubCategoriesDropdown extends StatelessWidget {
  const HealthEmergencySubCategoriesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencyCubit = context.read<HealthEmergencyCubit>();

    return BlocBuilder<HealthEmergencyCubit, HealthEmergencyState>(
      buildWhen: (previous, current) =>
          current is HealthEmergencySubCategoriesLoaded ||
          current is HealthEmergencyInitial,
      builder: (context, state) {
        if (state is HealthEmergencySubCategoriesLoaded) {
          return DropdownMenu<SubCategoryEntity>(
              width: MediaQuery.of(context).size.width * 0.9,
              hintText: LocaleKeys.speciality.localize,
              dropdownMenuEntries: state.subCategories
                  .map((e) => DropdownMenuEntry<SubCategoryEntity>(
                      value: e, label: e.name))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  emergencyCubit.selectSubcategory(value);
                }
              });
        } else {
          return Text("can't select spiciality", style: Styles.headerText());
        }
      },
    );
  }
}
