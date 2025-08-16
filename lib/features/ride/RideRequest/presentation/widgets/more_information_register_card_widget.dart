import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_switch_button.dart';

class MoreInformationRegisterCardWidget extends StatefulWidget {
  const MoreInformationRegisterCardWidget({super.key});

  @override
  State<MoreInformationRegisterCardWidget> createState() =>
      _MoreInformationRegisterCardWidgetState();
}

class _MoreInformationRegisterCardWidgetState
    extends State<MoreInformationRegisterCardWidget> {
  Map<String, dynamic>? workingType;
  Map<String, dynamic>? vehicleType;
  List<Map<String, dynamic>> workingTypelist = [];
  String? selectCity;
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    workingTypelist = [
      {
        "value": "percentage",
        "name": context.isArabic ? "نسبة مئوية" : "Percentage"
      },
      {
        "value": "subscribePackage",
        "name": context.isArabic ? "اشترك في الباقة" : "Subscribe Package"
      },
    ];
    final registerRider = context.read<RegisterRiderCubit>();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.isDarkMode
              ? AppColors.UNSELECTED_DARK_GRAY_COLOR
              : Colors.white,
          boxShadow: context.isDarkMode
              ? []
              : [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]),
      child: Column(
        children: [
          FormField(
            validator: (value) {
              if (workingType == null) {
                return context.isArabic
                    ? "يرجى اختيار خطة الاشتراك"
                    : "Please select subscription plan";
              }
              return null;
            },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        border: field.hasError
                            ? Border.all(color: AppColors.SECONDARY_COLOR_DARK)
                            : null,
                        color: context.isDarkMode
                            ? Colors.black12
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<Map<String, dynamic>>(
                            underline: Container(),
                            icon: Container(),
                            hint: workingType == null
                                ? Text(context.isArabic
                                    ? "خطة الاشتراك"
                                    : "Subscription plan")
                                : Text(workingType!['name'].toString()),
                            items: workingTypelist
                                .map(
                                  (e) => DropdownMenuItem<Map<String, dynamic>>(
                                    value: e,
                                    child: Text(e['name'] ?? ""),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              // context
                              //     .read<SelectCarModelBrandYearRideCubit>()
                              //     .selectColor(value: value);
                              context
                                  .read<RegisterRiderCubit>()
                                  .model
                                  .workingType = value?['value'];
                              workingType = value ?? workingType;
                              setState(() {});
                            },
                            dropdownColor: context.isDarkMode
                                ? AppColors.DARK_BLUE_COLOR
                                : Colors.white,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                  ),
                  if (field.hasError)
                    ValidationErrorWidget(
                      message: field.errorText ?? "",
                    )
                ],
              );
            },
          ),
          const Sizer(),
          BlocBuilder<HealthCubit, HealthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const CustomCircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                );
              }
              return FormField(
                validator: (value) {
                  if (selectCity == null) {
                    return context.isArabic
                        ? "يرجى اختيار المدينة"
                        : "Please select a city";
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            border: field.hasError
                                ? Border.all(
                                    color: AppColors.SECONDARY_COLOR_DARK)
                                : null,
                            color: context.isDarkMode
                                ? Colors.black12
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton<GovernorateEntity>(
                                underline: Container(),
                                icon: Container(),
                                hint: Text((selectCity) ??
                                    (context.isArabic
                                        ? "المدينة المفضلة"
                                        : "Favorite city")),
                                items: state.governorates!
                                    .map(
                                      (e) =>
                                          DropdownMenuItem<GovernorateEntity>(
                                        value: e,
                                        child: Text((context.isArabic
                                                ? e.nameAr
                                                : e.nameEn) ??
                                            ""),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  registerRider.model.governorateNameAr =
                                      value?.nameAr ?? "";
                                  selectCity = (context.isArabic
                                          ? value?.nameAr
                                          : value?.nameEn) ??
                                      "";

                                  setState(() {});
                                },
                                dropdownColor: context.isDarkMode
                                    ? AppColors.DARK_BLUE_COLOR
                                    : Colors.white,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_outlined)
                          ],
                        ),
                      ),
                      if (field.hasError)
                        ValidationErrorWidget(message: field.errorText ?? "")
                    ],
                  );
                },
              );
            },
          ),
          const Sizer(),
          DefaultTextFormField(
            onChanged: (value) {
              context.read<RegisterRiderCubit>().model.pricingPerKm =
                  double.tryParse(value) ?? 0;
            },
            isAuthentcation: true,
            hint: LocaleKeys.pricingPerKm.tr(),
            hintColor: AppColors.PRIMARY_COLOR,
            currentController: phoneController,
            keyboardType: TextInputType.number,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return LocaleKeys.phoneIsRequired.tr();
              }
              return null;
            },
          ),
          const Sizer(),
          if (registerRider.model.subcategoryId == "6698736fdaa111da2d775627")
            Column(
              children: [
                Row(
                  children: [
                    CustomSwitchButton(
                      // inactiveTrackColor: AppColors.GREY_LIGHT_COLOR,
                      onChanged: (value) {
                        setState(() {
                          if (context.isUserLoggedIn) {
                            registerRider.model.airCondition = value;
                          } else {
                            return pleaseLoginDialog(context);

                            // context.pushNamed(Routes.LOGIN);
                          }
                        });
                      },
                      value: registerRider.model.airCondition ?? false,
                    ),
                    const Sizer(),
                    Text(
                      LocaleKeys.airConditionAc.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomSwitchButton(
                      // inactiveTrackColor: AppColors.GREY_LIGHT_COLOR,
                      onChanged: (value) {
                        setState(() {
                          if (context.isUserLoggedIn) {
                            registerRider.model.smoker = value;
                          } else {
                            return pleaseLoginDialog(context);

                            // context.pushNamed(Routes.LOGIN);
                          }
                        });
                      },
                      value: registerRider.model.smoker ?? false,
                    ),
                    const Sizer(),
                    Text(
                      LocaleKeys.Smoker.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}
