import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    return DropdownMenu(
                        menuHeight: MediaQuery.of(context).size.height / 1.5,
                        menuStyle: const MenuStyle(
                          visualDensity: VisualDensity.comfortable,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: st is ValidationState &&
                                        (st.isSubCategory ?? true)
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                          constraints: BoxConstraints.loose(Size.fromHeight(90.h)),

                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: st is ValidationState &&
                                        (st.isGovernorate ?? true)
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: st is ValidationState &&
                                        (st.isGovernorate ?? true)
                                    ? Colors.red
                                    : Colors.grey),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: LocaleKeys.selectGovernorate.tr(),
                        dropdownMenuEntries: state.governorates
                            .map((e) =>
                                DropdownMenuEntry(value: e, label: e.nameEn))
                            .toList(),
                        onSelected: onSelected);
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
                        child: Text(
                          "You have to selecte your governorate!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  })
                ],
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
