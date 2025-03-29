import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_dropdown_health.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorSubcategoryDropdown extends StatelessWidget {
  const CreateDoctorSubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) =>
          current is CreateDoctorSubCategoriesLoaded,
      builder: (context, state) {
        if (state is CreateDoctorSubCategoriesLoaded) {
          return CustomDropdownHealth<SubCategoryEntity>(
            items: state.subCategories,
            onItemSelected: (value) {
              if (value != null) {
                createDoctorCubit.selectSubcategory(value);
              }
            },
            displayStringForItem: (value) =>
                context.isArabic ? value.nameAr : value.nameEn,
            hint: LocaleKeys.speciality.tr(),
          );
          return DropdownMenu<SubCategoryEntity>(
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: Styles.mediumText(),
                isDense: true,
                constraints: BoxConstraints.loose(
                  Size.fromHeight(90.h),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // contentPadding: EdgeInsets.symmetric(
                //   vertical: 5.h,
                //   horizontal: 10.w,
                // ),
              ),
              menuHeight: MediaQuery.of(context).size.height / 1.5,
              menuStyle: const MenuStyle(
                visualDensity: VisualDensity.comfortable,
              ),
              width: 100,
              hintText: LocaleKeys.speciality.tr(),
              dropdownMenuEntries: state.subCategories
                  .map((e) => DropdownMenuEntry<SubCategoryEntity>(
                      value: e, label: context.isArabic ? e.nameAr : e.nameEn))
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  createDoctorCubit.selectSubcategory(value);
                }
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
