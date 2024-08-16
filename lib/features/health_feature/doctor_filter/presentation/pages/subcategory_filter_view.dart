import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategories_list.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DoctorSubcategoryFilterView extends StatelessWidget {
  const DoctorSubcategoryFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorSubcategoryFilter =
        context.read<DoctorSubcategoryFilterCubit>();
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.speciality,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextFormField(
              hintColor: Theme.of(context).scaffoldBackgroundColor,
              currentFocusNode: doctorSubcategoryFilter.searchFocusNode,
              currentController: doctorSubcategoryFilter.searchController,
              hint: Labels.search,
              prefixIcon:  const Icon(Icons.search,color: AppColors.QUANTITY_COLOR,),
              onChanged: (value) => doctorSubcategoryFilter.search(value),
            ),
            const Sizer(
              height: 30,
            ),
            const DoctorsSubcategoriesFilterList()
          ],
        ),
      ),
    );
  }
}
