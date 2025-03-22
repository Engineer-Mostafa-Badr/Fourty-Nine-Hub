import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/widget/custom_switch_list_title.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/widgets/register_expansion_tile.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../widgets/close_widget.dart';
import '../widgets/upload_file_widget.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
      var cubit = context.read<RideCubit>();
      return CustomScaffold(
        appBar: const HomeAppbar(),
        body: Form(
          key: context.read<RideCubit>().formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 32,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        closeWidget(context),
                        Label(
                          text: LocaleKeys.personalInformation.localize,
                          style: Styles.headerText(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if(state.registerType=='socket')...[const Sizer(),
                        UploadFileWidget(
                          title: LocaleKeys.personalPicture.localize,
                          onTap: () {
                            cubit.onUploadPersonalPicture(context);
                          },
                          imageUrl: state.personalPicture,
                        )],
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideNameController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.firstName.localize,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideSurNameController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.surname.localize,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        if(state.isShipping!=true)...[DatePickerTextField(color:AppColors.GREYBG,initialDate: DateTime.now(), minDate: DateTime(1900), maxDate: DateTime(2090),onDateSelected: (date){
                          cubit.rideDateOfBirthController.text = DateFormat('yyyy-MM-dd').format(date??DateTime.now());
                        }, controller:cubit.rideDateOfBirthController,hintText: LocaleKeys.user_info_date_of_birth.localize,),
                        const Sizer()],
                        DefaultTextFormField(
                          currentController: cubit.ridePhoneNumberController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.phoneNumber.localize,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.ridePersonalDocIdNumController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.idNumber.localize,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        if(state.isShipping!=true)...[DefaultTextFormField(
                          currentController: cubit.ridePersonalDocLicenseNumController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.licenseNumber.localize,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer()],
                        if(state.registerType=='socket')...[RegisterExpansionTile(
                          title: (state.selectedColors != null || (state.selectedColors?.id.isNotEmpty ?? false))
                              ? Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HexColor(state.selectedColors?.code ?? ''),
                                      ),
                                    ),
                                    const Sizer(),
                                    Label(
                                      text: context.isArabic ? state.selectedColors?.nameAr ?? '' : state.selectedColors?.nameEn ?? '',
                                    )
                                  ],
                                )
                              : Label(text: LocaleKeys.vehicleColor.localize),
                          onChange: (Widget selectedItem) {},
                          onSelect: (i) => cubit.onSelectColor(state.colors![i]),
                          length: state.colors?.length ?? 0,
                          children: List.generate(
                              state.colors?.length ?? 0,
                              (index) => Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: HexColor(state.colors?[index].code ?? ''),
                                        ),
                                      ),
                                      const Sizer(),
                                      Label(text: context.isArabic ? (state.colors?[index].nameAr ?? '') : state.colors?[index].nameEn ?? ''),
                                    ],
                                  )),
                        ),
                        const Sizer(),
                        RegisterExpansionTile(
                          title: Label(
                              text: (state.selectedBrand != null || (state.selectedBrand?.isNotEmpty ?? false)) ? state.selectedBrand ?? '' : LocaleKeys.vehicleBrand.localize),
                          onChange: (selectedItem) {
                            cubit.onSelectBrand((selectedItem as Label).text, context);
                          },
                          length: state.brands?.length ?? 0,
                          children: List.generate(state.brands?.length ?? 0, (index) => Label(text: state.brands?[index] ?? '')),
                        ),
                        const Sizer(),
                        state.isLoadingModels
                            ? const Center(child: CircularProgressIndicator())
                            : RegisterExpansionTile(
                                title: Label(
                                    text:
                                        (state.selectedModel != null || (state.selectedModel?.isNotEmpty ?? false)) ? state.selectedModel ?? '' : LocaleKeys.vehicleModel.localize),
                                onChange: (Widget selectedItem) {
                                  cubit.onSelectModel((selectedItem as Label).text);
                                },
                                length: state.models?.length ?? 0,
                                children: List.generate(state.models?.length ?? 0, (index) => Label(text: state.models?[index] ?? '')),
                              ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideVehicleProductionYearController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.yearOfProduction.localize,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),],
                        if(state.registerType=='noSocket')...[DefaultTextFormField(
                          currentController: cubit.rideCarModelController,
                          hint: LocaleKeys.carModel.tr(),
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer()],
                        DefaultTextFormField(
                          currentController: cubit.rideVehiclePlateNumberController,
                          hint: LocaleKeys.plateInformation.tr(),
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        if(state.registerType=='socket')...[const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideVehicleLicenseNumController,
                          hint: context.isArabic ? "رقم ترخيص السيارة" : "Vehicle License Number",
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        RegisterExpansionTile(
                          title: Label(
                              text: (state.selectedPlan != null || (state.selectedPlan?.isNotEmpty ?? false)) ? state.selectedPlan ?? '' : LocaleKeys.subscriptionPlan.localize),
                          onChange: (Widget selectedItem) {
                            cubit.onSelectPlan((selectedItem as Label).text);
                            // print("Selected Item: ${(selectedItem as Label).text}");
                          },
                          length: cubit.subscriptionPlans.length,
                          children: List.generate(cubit.subscriptionPlans.length, (index) => Label(text: cubit.subscriptionPlans[index])),
                        ),

                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.ridePricingPerKmController,
                          hint: LocaleKeys.pricingPerKm.localize,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return LocaleKeys.required.localize;
                            }else{
                              if((num.tryParse(v) ?? 0) >(state.costPerKm?.highCostPerKm??0)||(num.tryParse(v) ?? 0) <(state.costPerKm?.lowCostPerKm??0)){
                                return context.isArabic?"يجب ان يكون السعر للكيلومتر بين ${state.costPerKm?.lowCostPerKm} و ${state.costPerKm?.highCostPerKm}":'Must be between ${state.costPerKm?.lowCostPerKm} and ${state.costPerKm?.highCostPerKm}';
                              }
                            }
                            return null;
                          },
                        ),
                        const Sizer(),
                        CustomSwitchListTile(
                          title: Text(
                            LocaleKeys.nonSmokerDriver.localize,
                            style: Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400),
                          ),
                          value: state.isSmoking ?? false,
                          onChanged: (value) async {
                            cubit.onChangeSmokingValue();
                          },
                        ),
                        CustomSwitchListTile(
                          title: Text(
                            "Air Conditioner",
                            style: Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400),
                          ),
                          value: state.hasAirCondition ?? false,
                          onChanged: (value) async {
                            cubit.onChangeAirCondition();
                          },
                        )],
                        if(state.registerType=='socket'||state.isShipping==true)...[const Sizer(),RegisterExpansionTile(
                          title: Label(
                            text: (state.selectedGov != null || (state.selectedGov?.isNotEmpty ?? false)) ? state.selectedGov ?? '' : LocaleKeys.favoriteCity.localize,
                          ),
                          onChange: (Widget selectedItem) {
                            cubit.onSelectGov((selectedItem as Label).text);
                            // print("Selected Item: ${(selectedItem as Label).text}");
                          },
                          length: state.govs?.length ?? 0,
                          children: List.generate(
                              state.govs?.length ?? 0, (index) => Label(text: context.isArabic ? (state.govs?[index].nameAr ?? '') : state.govs?[index].nameEn ?? '')),
                        )],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 32,
                  top: 8.0,
                  right: 12,
                  left: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.GREYBG,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    const Sizer(),
                    InkWell(
                            onTap: () {
                              state.isShipping==true?cubit.onLoadingRegister(context):state.registerType=='socket'?cubit.onRegister(context):cubit.onNoSocketRegister(context);
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Label(
                                    text: LocaleKeys.submit.localize,
                                    style: Styles.headerText(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.AUTH_CONTAINER_COLOR,
                                    ),
                                  ),
                                  const Sizer(),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.AUTH_CONTAINER_COLOR,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
