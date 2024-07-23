import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/area_filtercubit/doctor_area_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/area_list_title.dart';

class DoctorAreaFilterView extends StatelessWidget {
  const DoctorAreaFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorAreaFilter = context.read<DoctorAreaFilterCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Filter'),
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
              currentFocusNode: doctorAreaFilter.searchFocusNode,
              currentController: doctorAreaFilter.searchController,
              hint: 'Search For Speciality',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorAreaFilter.search(value),
            ),
            const Sizer(
              height: 30,
            ),
            BlocBuilder<DoctorAreaFilterCubit, DoctorAreaFilterState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorAreaFilterLoaded _:
                    return Expanded(
                        child: ListView.separated(
                      itemCount: state.areas.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          AreaListTitle(area: state.areas[index]),
                    ));
                  case DoctorAreaFilterError _:
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