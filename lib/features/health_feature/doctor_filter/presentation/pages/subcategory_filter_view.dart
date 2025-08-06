import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/widgets/subcategories_list.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';

class DoctorSubcategoryFilterView extends StatefulWidget {
  const DoctorSubcategoryFilterView({super.key, required this.type});
  final String type;

  @override
  State<DoctorSubcategoryFilterView> createState() => _DoctorSubcategoryFilterViewState();
}

class _DoctorSubcategoryFilterViewState extends State<DoctorSubcategoryFilterView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctorSubcategoryFilter = context.read<DoctorSubcategoryFilterCubit>();
      doctorSubcategoryFilter.searchFocusNode.requestFocus();
    });
  }
  @override
  Widget build(BuildContext context) {
    final doctorSubcategoryFilter =
        context.read<DoctorSubcategoryFilterCubit>();
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          color: AppColors.whiteColor,
          isWithBackArrow: true,
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
            Label(
              text: LocaleKeys.speciality.localize,
              style: Styles.headerText(fontWeight: FontWeight.w600),
            ),
            Sizer(),
            DefaultTextFormField(
              hintColor: Theme.of(context).scaffoldBackgroundColor,
              currentFocusNode: doctorSubcategoryFilter.searchFocusNode,
              currentController: doctorSubcategoryFilter.searchController,
              hint: LocaleKeys.search.localize,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.getTextColor(context),
              ),
              onChanged: (value) => doctorSubcategoryFilter.search(value),
            ),
            Sizer(
              height: 30.h,
            ),
            DoctorsSubcategoriesFilterList(
              type: widget.type,
            )
          ],
        ),
      ),
    );
  }
}
