import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorSubcategoryDropdown extends StatelessWidget {
  final List<SubCategoryEntity>? subCategories;
  const CreateDoctorSubcategoryDropdown({super.key, this.subCategories});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    if (subCategories != null && subCategories!.isNotEmpty) {
      return DropdownMenu<SubCategoryEntity>(
          width: MediaQuery.of(context).size.width * 0.9,
          hintText: "Subcateogry",
          enabled: subCategories != null && subCategories!.isNotEmpty,
          dropdownMenuEntries: subCategories!
              .map((e) =>
                  DropdownMenuEntry<SubCategoryEntity>(value: e, label: e.name))
              .toList(),
          onSelected: (value) {
            if (value != null) {
              // createDoctorCubit.selectSubGategory(value);
            }
          });
    } else {
      return Text("can't select sub category", style: Styles.headerText());
    }
  }
}
