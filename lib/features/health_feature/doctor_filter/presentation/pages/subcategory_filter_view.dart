import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategories_list.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class DoctorSubcategoryFilterView extends StatelessWidget {
  const DoctorSubcategoryFilterView({super.key, required this.type});
  final String type;
  @override
  Widget build(BuildContext context) {
    final doctorSubcategoryFilter =
        context.read<DoctorSubcategoryFilterCubit>();
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.speciality.localize,
        ),
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
              hintColor: Theme.of(context).scaffoldBackgroundColor,
              currentFocusNode: doctorSubcategoryFilter.searchFocusNode,
              currentController: doctorSubcategoryFilter.searchController,
              hint: LocaleKeys.search.localize,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.QUANTITY_COLOR,
              ),
              onChanged: (value) => doctorSubcategoryFilter.search(value),
            ),
            Sizer(
              height: 30.h,
            ),
            DoctorsSubcategoriesFilterList(
              type: type,
            )
          ],
        ),
      ),
    );
  }
}
