import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/governorate_list_title.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class DoctorGovernorateFilterView extends StatelessWidget {
  const DoctorGovernorateFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorGovernorateFilter =
        context.read<DoctorGovernorateFilterCubit>();
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.governorate.localize,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextFormField(
              currentFocusNode: doctorGovernorateFilter.searchFocusNode,
              currentController: doctorGovernorateFilter.searchController,
              hint: LocaleKeys.search.localize,
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorGovernorateFilter.search(value),
            ),
            Sizer(
              height: 30.h,
            ),
            // BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
            //   if (state.governorates != null && state.governorates!.isNotEmpty) {
            //     return Expanded(
            //         child: ListView.separated(
            //           itemCount: state.governorates!.length,
            //           separatorBuilder: (context, index) =>  Divider(),
            //           itemBuilder: (context, index) => GovernorateListTitle(
            //               governorate: state.governorates![index]),
            //         ));
            //   } else {
            //     return  SizedBox.shrink();
            //   }
            // }),
            BlocBuilder<DoctorGovernorateFilterCubit,
                DoctorGovernorateFilterState>(
              builder: (context, state) {
                if (state is DoctorGovernorateFilterLoaded) {
                  return Expanded(
                      child: ListView.separated(
                    itemCount: state.governorates.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => GovernorateListTitle(
                        governorate: state.governorates[index]),
                  ));
                } else {
                  return const SizedBox.shrink();
                }
                // switch (state) {
                //   case DoctorGovernorateFilterLoaded _:
                //     return Expanded(
                //         child: ListView.separated(
                //           itemCount: state.governorates.length,
                //           separatorBuilder: (context, index) =>  Divider(),
                //           itemBuilder: (context, index) => GovernorateListTitle(
                //               governorate: state.governorates[index]),
                //         ));
                //   case DoctorGovernorateFilterError _:
                //     return Center(child: Text(state.message));
                //   default:
                //     return  Center(child: CircularProgressIndicator());
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
