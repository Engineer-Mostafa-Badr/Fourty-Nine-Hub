import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/media_query_values.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../health_feature/shared/domain/entities/governorate_entity.dart';
import '../../../../../../res/style/styles.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../cubit/create_restaurant_cubit.dart';

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
                    return DropdownButtonFormField<GovernorateEntity>(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.getTextColor(context),
                      ),
                      style: Styles.mediumText(
                          color: AppColors.getTextColor(context)),
                      dropdownColor: AppColors.getFillColor(context),
                      decoration: InputDecoration(
                        fillColor: AppColors.getFillColor(context),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: st is ValidationState &&
                                    (st.isSubCategory ?? true)
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      hint: Text(
                        LocaleKeys.selectGovernorate.localize,
                        style: Styles
                            .mediumText(), // You can adjust this hint style as needed
                      ),
                      menuMaxHeight: context.height / 2,
                      items: state.governorates.map((e) {
                        return DropdownMenuItem<GovernorateEntity>(
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
