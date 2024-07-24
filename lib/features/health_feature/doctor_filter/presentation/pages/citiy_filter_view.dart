import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/city_list_title.dart';

class DoctorCityFilterView extends StatelessWidget {
  final GovernorateEntity governorate;
  const DoctorCityFilterView({super.key, required this.governorate});

  @override
  Widget build(BuildContext context) {
    final doctorCityFilter = context.read<DoctorCityFilterCubit>()
      ..loadData(governorateId: governorate.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Filter'),
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
              currentFocusNode: doctorCityFilter.searchFocusNode,
              currentController: doctorCityFilter.searchController,
              hint: 'Search For Speciality',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorCityFilter.search(value),
            ),
            const Sizer(
              height: 30,
            ),
            BlocBuilder<DoctorCityFilterCubit, DoctorCityFilterState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorCityFilterLoaded _:
                    return Expanded(
                        child: ListView.separated(
                      itemCount: state.cities.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          CityListTitle(city: state.cities[index]),
                    ));
                  case DoctorCityFilterError _:
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
