import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategory_list_title.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DoctorsSubcategoriesFilterList extends StatelessWidget {
  const DoctorsSubcategoriesFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorSubcategoryFilterCubit,
        DoctorSubcategoryFilterState>(
      builder: (context, state) {
        switch (state) {
          case DoctorSubcategoryFilterLoaded _:
            return Expanded(
                child: ListView.separated(
              itemCount: state.subCategories.length,
              separatorBuilder: (context, index) =>   const SizedBox(height: 10,),
              itemBuilder: (context, index) =>
                  SubcategoryListTitle(specialty: state.subCategories[index]),
            ));
          case DoctorSubcategoryFilterError _:
            return Center(child: Text(state.message));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
