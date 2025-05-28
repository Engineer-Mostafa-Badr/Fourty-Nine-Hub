import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/page_name_row.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/speciality_dropdown.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class EmergencyView extends StatefulWidget {
  const EmergencyView({
    super.key,
  });

  @override
  State<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends State<EmergencyView> {
  List specialities = [
    'Ear/nose',
    'Neurologist',
    'Cardiologist',
    'Dentist',
    'Ophthalmologist',
    'Surgeon',
    'Physiotherapist',
    'Psychiatrist',
    'Psychiatrist',
    'Anesthesiologist',
    'Gynecologist',
    'Pediatricia',
    'Ivf',
    'Rheumatologist',
    'Jaw bone',
  ];
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: BlocBuilder<HealthCubit, HealthState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                children: [
                  PageNameRow(
                    title: LocaleKeys.emergency.localize,
                  ),
                  const Sizer(),
                  _buildTextFormField(hint: LocaleKeys.firstName.localize),
                  const Sizer(),
                  _buildTextFormField(hint: LocaleKeys.phoneNumber.localize),
                  const Sizer(),
                  SpecialityDropdown(
                    items: specialities,
                    onItemSelected: (_) {},
                    displayStringForItem: (value) => value,
                    hint: LocaleKeys.speciality.localize,
                  ),
                  const Sizer(),
                  _buildTextFormField(hint: '${LocaleKeys.address.localize}*'),
                  const Sizer(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 76.h,
                      decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR_DARK2,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.confirm.localize,
                          style: Styles.headerText(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  _buildTextFormField({required String hint}) {
    return FormTextField(
      height: 88.h,
      hint: hint,
      style: Styles.mediumText(fontWeight: FontWeight.w600, fontSize: 32),
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      borderColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
    );
  }
}
