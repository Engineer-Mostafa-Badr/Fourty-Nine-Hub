import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateRestaurantGovernorateDropdown extends StatelessWidget {
  const CreateRestaurantGovernorateDropdown(
      {super.key, this.onSelected, this.validator});
  final void Function(GovernorateEntity? value)? onSelected;
  final String? Function(Object? value)? validator;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      buildWhen: (previous, current) =>
          current is CreateRestaurantGovernoratesLoaded,
      builder: (context, state) {
        if (state is CreateRestaurantGovernoratesLoaded) {
          return FormField(
            validator: validator,
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                      builder: (context, st) {
                    return DropdownButtonFormField(
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        constraints:
                            BoxConstraints.loose(Size.fromHeight(90.h)),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isGovernorate ?? true)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isGovernorate ?? true)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                      hint: Text(LocaleKeys.selectGovernorate.tr()),
                      items: state.governorates.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(context.isArabic ? e.nameAr : e.nameEn),
                        );
                      }).toList(),
                      onChanged: onSelected,
                      isExpanded: true,
                    );
                  }),
                  if (field.hasError)
                    Column(
                      children: [
                        SizedBox(height: 8.h),
                        Text(
                          field.errorText ?? "",
                          style: Styles.mediumText(color: Colors.red),
                        ),
                      ],
                    ),
                  BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                      builder: (context, state) {
                    return Visibility(
                      visible: state is ValidationState &&
                          (state.isGovernorate ?? true),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                        child: Text(
                          LocaleKeys.youHaveToSelectYourGovernorate.localize,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  })
                ],
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
