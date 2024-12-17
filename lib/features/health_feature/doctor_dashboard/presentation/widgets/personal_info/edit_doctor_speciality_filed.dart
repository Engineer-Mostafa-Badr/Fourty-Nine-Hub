import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class EditDoctorSpecialityField extends StatelessWidget {
  const EditDoctorSpecialityField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDoctorPersonalInfoCubit,EditDoctorPersonalInfoState>(
      builder: (context,state) {
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
            initialSelection: state.selectedSpeciality!=null?state.speciality?.firstWhere((element) => element.id==state.selectedSpeciality):null,
            menuHeight: MediaQuery.of(context).size.height / 1.5,
            menuStyle: const MenuStyle(
              visualDensity: VisualDensity.comfortable,
            ),
            width: 100,
            hintText: LocaleKeys.speciality.localize,
            dropdownMenuEntries: state.speciality
                ?.map((e) => DropdownMenuEntry<SubCategoryEntity>(
                value: e, label:context.isArabic? e.nameAr: e.nameEn))
                .toList()??[],
            onSelected: (value) {
              if (value != null) {
                context.read<EditDoctorPersonalInfoCubit>().onSelectSpeciality(value);
              }
            });
      }
    );
  }
}
