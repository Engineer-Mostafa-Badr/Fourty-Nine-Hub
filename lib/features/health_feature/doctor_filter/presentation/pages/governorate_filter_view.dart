import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/governorate_list_title.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class DoctorGovernorateFilterView extends StatelessWidget {
  const DoctorGovernorateFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorGovernorateFilter = context.read<DoctorGovernorateFilterCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(
        label: Labels.governorate,
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
              currentFocusNode: doctorGovernorateFilter.searchFocusNode,
              currentController: doctorGovernorateFilter.searchController,
              hint: Labels.search,
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorGovernorateFilter.search(value),
            ),
            const Sizer(
              height: 30,
            ),
            BlocBuilder<DoctorGovernorateFilterCubit, DoctorGovernorateFilterState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorGovernorateFilterLoaded _:
                    return Expanded(
                        child: ListView.separated(
                      itemCount: state.governorates.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          GovernorateListTitle(governorate: state.governorates[index]),
                    ));
                  case DoctorGovernorateFilterError _:
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