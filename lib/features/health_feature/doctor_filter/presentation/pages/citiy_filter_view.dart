import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/city_list_title.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class DoctorCityFilterView extends StatefulWidget {
  const DoctorCityFilterView({
    super.key,
    required this.type,
  });
  final String type;

  @override
  State<DoctorCityFilterView> createState() => _DoctorCityFilterViewState();
}

class _DoctorCityFilterViewState extends State<DoctorCityFilterView> {
  @override
  void initState() {
    context.read<DoctorCityFilterCubit>().loadData(
        governorateId: serviceLocator<HealthSharedData>()
            .doctorSearchParams
            .governorate
            .id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doctorCityFilter = context.read<DoctorCityFilterCubit>();
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.city.localize,
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
              currentFocusNode: doctorCityFilter.searchFocusNode,
              currentController: doctorCityFilter.searchController,
              hint: LocaleKeys.search.localize,
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => doctorCityFilter.search(value),
            ),
            Sizer(
              height: 30.h,
            ),
            BlocBuilder<DoctorCityFilterCubit, DoctorCityFilterState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorCityFilterLoaded _:
                    return Expanded(
                        child: ListView.separated(
                      itemCount: state.cities.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => CityListTitle(
                        city: state.cities[index],
                        type: widget.type,
                      ),
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
