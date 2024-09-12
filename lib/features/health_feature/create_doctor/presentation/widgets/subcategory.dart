import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class CreateDoctorSubcategoryDropdown extends StatelessWidget {
  const CreateDoctorSubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorSubCategoriesLoaded,
      builder: (context, state) {
        if (state is CreateDoctorSubCategoriesLoaded) {
          return DropdownMenu<SubCategoryEntity>(
              width: MediaQuery.of(context).size.width * 0.9,
              hintText: "Spiciality",
              dropdownMenuEntries: state.subCategories
                  .map((e) => DropdownMenuEntry<SubCategoryEntity>(
                      value: e, label: e.name))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createDoctorCubit.selectSubcategory(value);
                }
              });
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
