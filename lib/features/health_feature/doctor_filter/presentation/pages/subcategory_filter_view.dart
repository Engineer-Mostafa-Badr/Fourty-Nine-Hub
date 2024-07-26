import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/enums/doctor_services.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategory_list_title.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorSubcategoryFilterView extends StatelessWidget {
  final DoctorServices doctorService;
  const DoctorSubcategoryFilterView({super.key, required this.doctorService});

  @override
  Widget build(BuildContext context) {
    final doctorSubcategoryFilter =
        context.read<DoctorSubcategoryFilterCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speciality Filter'),
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
              currentFocusNode: doctorSubcategoryFilter.searchFocusNode,
              currentController: doctorSubcategoryFilter.searchController,
              hint: 'Search For Speciality',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorSubcategoryFilter.search(value),
            ),
            const Sizer(
              height: 30,
            ),
            Text(
              'Most Popular Specialities',
              style: Styles.headerText(),
            ),
            const Sizer(
              height: 30,
            ),
            BlocBuilder<DoctorSubcategoryFilterCubit,
                DoctorSubcategoryFilterState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorSubcategoryFilterLoaded _:
                    return Expanded(
                        child: ListView.separated(
                      itemCount: state.subCategories.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => SubcategoryListTitle(
                          specialty: state.subCategories[index],service:doctorService),
                    ));
                  case DoctorSubcategoryFilterError _:
                    return Center(child: Text(state.message));  
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
