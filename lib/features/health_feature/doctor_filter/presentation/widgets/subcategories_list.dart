import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategory_list_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsSubcategoriesFilterList extends StatelessWidget {
  const DoctorsSubcategoriesFilterList({super.key, required this.type});
  final String type;

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
              separatorBuilder: (context, index) => SizedBox(
                height: 10.h,
              ),
              itemBuilder: (context, index) =>
                  SubcategoryListTitle(specialty: state.subCategories[index], type: type,),
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
