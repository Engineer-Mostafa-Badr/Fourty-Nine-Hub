import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/core/widget/custom_switch_list_title.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/widgets/register_expansion_tile.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../widgets/close_widget.dart';
import '../widgets/upload_file_widget.dart';

class RideFeatureRegisterParams {
  final bool isSocket;
  final bool isShipping;
  final List<String> subCategoriesId;

  RideFeatureRegisterParams({required this.isSocket, required this.isShipping, required this.subCategoriesId});
}

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key, required this.params});
  final RideFeatureRegisterParams params;
  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  void initState() {
    print("widget.params.subCategoriesId: ${widget.params.subCategoriesId}");
    context.read<RideRegisterCubit>().loadRegisterData(context, widget.params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideRegisterCubit, RideRegisterState>(builder: (context, state) {
      var cubit = context.read<RideRegisterCubit>();
      final DateTime now = DateTime.now();
      final DateTime earliestDate = DateTime(now.year - 65, now.month, now.day);
      final DateTime latestDate = DateTime(now.year - 21, now.month, now.day);
      return PopScope(
        canPop: false,
        child: CustomScaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: HomeAppbar(),
          ),
          body: cubit.loadingRegister == true
              ? const Center(child: CustomCircularProgressIndicator())
              : Form(
                  key: context.read<RideRegisterCubit>().formKey,
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
                                closeWidget(
                                    context: context,
                                    onAcceptSaveData: () {
                                      if (widget.params.isShipping == true) {
                                        cubit.onSaveRegisterLoaderData(context, widget.params.subCategoriesId);
                                      } else {
                                        if (widget.params.isSocket == false) {
                                          cubit.onSaveRegisterNoSocketData(context, widget.params.subCategoriesId);
                                        } else {
                                          cubit.onSaveRegisterData(context, widget.params.subCategoriesId);
                                        }
                                      }
                                    },
                                    closeRemoveData: () {
                                      if (widget.params.isShipping == true) {
                                        cubit.onRemoveLoaderData(context);
                                      } else {
                                        if (widget.params.isSocket == false) {
                                          cubit.onRemoveNoSocketData(context);
                                        } else {
                                          cubit.onRemoveDriverData(context);
                                        }
                                      }
                                    }),
                                Label(
                                  text: LocaleKeys.personalInformation.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 32),
                                ),
                                if (state.registerType == 'socket') ...[
                                  const Sizer(),
                                  UploadFileWidget(
                                    title: LocaleKeys.personalPicture.localize,
                                    onTap: () {
                                      cubit.onUploadPersonalPicture(context);
                                    },
                                    imageUrl: state.personalPicture,
                                  )
                                ],
                                const Sizer(),
                                Label(
                                  text: LocaleKeys.firstName.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                ),
                                DefaultTextFormField(
                                  currentController: cubit.rideNameController,
                                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                  borderColor: Colors.transparent,
                                  hint: '',
                                  // label: LocaleKeys.firstName.localize,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return LocaleKeys.required.localize;
                                    }
                                    return null;
                                  },
                                ),
                                const Sizer(),
                                Label(
                                  text: LocaleKeys.surname.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                ),
                                DefaultTextFormField(
                                  currentController: cubit.rideSurNameController,
                                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                  borderColor: Colors.transparent,
                                  hint: '',
                                  // label: LocaleKeys.surname.localize,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return LocaleKeys.required.localize;
                                    }
                                    return null;
                                  },
                                ),
                                const Sizer(),
                                if (state.isShipping != true) ...[
                                  Label(
                                    text: LocaleKeys.user_info_date_of_birth.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  DatePickerTextField(
                                    color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                    initialDate: latestDate,
                                    minDate: earliestDate,
                                    maxDate: latestDate,
                                    onDateSelected: (date) {
                                      cubit.rideDateOfBirthController.text = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
                                    },
                                    controller: cubit.rideDateOfBirthController,
                                    hintText: '',
                                  ),
                                  const Sizer()
                                ],
                                Label(
                                  text: LocaleKeys.phoneNumber.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                ),
                                DefaultTextFormField(
                                  currentController: cubit.ridePhoneNumberController,
                                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                  borderColor: Colors.transparent,
                                  hint: '',
                                  // label: LocaleKeys.idNumber.localize,
                                  keyboardType: TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                    validator: (v)=>validatorPhone(v)
                                ),
                                const Sizer(),
                                Label(
                                  text: LocaleKeys.idNumber.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                ),
                                DefaultTextFormField(
                                  currentController: cubit.ridePersonalDocIdNumController,
                                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                  borderColor: Colors.transparent,
                                  hint: '',
                                  maxLength: 14,
                                  // label: LocaleKeys.idNumber.localize,
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return LocaleKeys.required.localize;
                                    }else if(v.length < 14){
                                      return context.isArabic?'رقم الهوية غير صحيح':'Id number is not valid';
                                    }
                                    return null;
                                  },
                                ),
                                const Sizer(),
                                if (state.isShipping != true) ...[
                                  Label(
                                    text: LocaleKeys.licenseNumber.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  DefaultTextFormField(
                                    currentController: cubit.ridePersonalDocLicenseNumController,
                                    fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                    borderColor: Colors.transparent,
                                    hint: '',
                                    maxLength: 14,
                                    // label: LocaleKeys.licenseNumber.localize,
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return LocaleKeys.required.localize;
                                      }else if(v.length < 14){
                                        return context.isArabic?'رقم الهوية غير صحيح':'Id number is not valid';
                                      }
                                      return null;
                                    },
                                  ),
                                  const Sizer()
                                ],
                                if (state.registerType == 'socket') ...[
                                  Label(
                                    text: LocaleKeys.vehicleColor.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  RegisterExpansionTile(
                                    initialTitle: (state.color != null || (state.color?.id.isNotEmpty ?? false))
                                        ? Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: HexColor(state.color?.code ?? ''),
                                                ),
                                              ),
                                              const Sizer(),
                                              Label(
                                                text: context.isArabic ? state.color?.nameAr ?? '' : state.color?.nameEn ?? '',
                                              )
                                            ],
                                          )
                                        : Label(text: LocaleKeys.vehicleColor.localize),
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
                                  Label(
                                    text: LocaleKeys.vehicleBrand.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  RegisterExpansionTile(
                                    initialTitle: Label(
                                        text: (state.selectedBrand != null || (state.selectedBrand?.isNotEmpty ?? false))
                                            ? state.selectedBrand ?? LocaleKeys.vehicleBrand.localize
                                            : LocaleKeys.vehicleBrand.localize),
                                    title: Label(
                                        text: (state.selectedBrand != null || (state.selectedBrand?.isNotEmpty ?? false))
                                            ? state.selectedBrand ?? LocaleKeys.vehicleBrand.localize
                                            : LocaleKeys.vehicleBrand.localize),
                                    onChange: (selectedItem) {
                                      cubit.onSelectBrand((selectedItem as Label).text, context);
                                    },
                                    length: state.brands?.length ?? 0,
                                    children: List.generate(state.brands?.length ?? 0, (index) => Label(text: context.isArabic? (state.brands?[index].brandNameAr ?? '') : state.brands?[index].brandNameEn ?? '')),
                                  ),
                                  const Sizer(),
                                  state.isLoadingModels
                                      ? const Center(child: CustomCircularProgressIndicator())
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Label(
                                              text: LocaleKeys.vehicleModel.localize,
                                              style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                            ),
                                            RegisterExpansionTile(
                                              // initialTitle: Label(
                                              //     text: (state.selectedModel != null || (state.selectedModel?.isNotEmpty ?? false)) ? state.selectedModel ?? '' :''),
                                              title: Label(
                                                  text: (state.selectedModel != null || (state.selectedModel?.isNotEmpty ?? false))
                                                      ? state.selectedModel ?? LocaleKeys.vehicleModel.localize
                                                      : LocaleKeys.vehicleModel.localize),
                                              onChange: (Widget selectedItem) {
                                                cubit.onSelectModel((selectedItem as Label).text);
                                              },
                                              length: state.models?.length ?? 0,
                                              children: List.generate(state.models?.length ?? 0, (index) => Label(text: context.isArabic?(state.models?[index].modelAr ?? ''):state.models?[index].modelEn ?? '')),
                                            ),
                                          ],
                                        ),
                                  const Sizer(),
                                  Label(
                                    text: LocaleKeys.yearOfProduction.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  DefaultTextFormField(
                                    currentController: cubit.rideVehicleProductionYearController,
                                    fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                    borderColor: Colors.transparent,
                                    hint: '',
                                    // label: LocaleKeys.yearOfProduction.localize,
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return LocaleKeys.required.localize;
                                      }
                                      return null;
                                    },
                                  ),
                                  const Sizer(),
                                ],
                                if (state.registerType == 'noSocket') ...[
                                  Label(
                                    text: LocaleKeys.carModel.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  DefaultTextFormField(
                                    currentController: cubit.rideCarModelController,
                                    hint: '',
                                    // label: LocaleKeys.carModel.tr(),
                                    fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                    borderColor: Colors.transparent,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return LocaleKeys.required.localize;
                                      }
                                      return null;
                                    },
                                  ),
                                  const Sizer()
                                ],
                                Label(
                                  text: LocaleKeys.plateInformation.localize,
                                  style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                ),
                                DefaultTextFormField(
                                  currentController: cubit.rideVehiclePlateNumberController,
                                  hint: '',
                                  // label: LocaleKeys.plateInformation.tr(),
                                  fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                                  borderColor: Colors.transparent,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return LocaleKeys.required.localize;
                                    }
                                    return null;
                                  },
                                ),
                                if (state.registerType == 'socket') ...[
                                  const Sizer(),
                                  // DefaultTextFormField(
                                  //   currentController: cubit.rideVehicleLicenseNumController,
                                  //   hint: context.isArabic ? "رقم ترخيص السيارة" : "Vehicle License Number",
                                  //   label: context.isArabic ? "رقم ترخيص السيارة" : "Vehicle License Number",
                                  //   fillColor:context.isDarkMode?AppColors.GREY_DARK_COLOR: AppColors.GREYBG,
                                  //   borderColor: Colors.transparent,
                                  //   keyboardType: TextInputType.number,
                                  //   validator: (v) {
                                  //     if (v == null || v.isEmpty) {
                                  //       return LocaleKeys.required.localize;
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                  // const Sizer(),
                                  Label(
                                    text: LocaleKeys.subscriptionPlan.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  RegisterExpansionTile(
                                    initialTitle: Label(
                                        text: (state.selectedPlan != null || (state.selectedPlan?.isNotEmpty ?? false))
                                            ? state.selectedPlan == 'percentage'
                                                ? 'Percentage'
                                                : 'Subscribe Package'
                                            : ''),
                                    title: Label(
                                        text: (state.selectedPlan != null || (state.selectedPlan?.isNotEmpty ?? false))
                                            ? state.selectedPlan ?? ''
                                            : LocaleKeys.subscriptionPlan.localize),
                                    onChange: (Widget selectedItem) {
                                      cubit.onSelectPlan((selectedItem as Label).text);
                                      // print("Selected Item: ${(selectedItem as Label).text}");
                                    },
                                    length: cubit.subscriptionPlans.length,
                                    children: List.generate(cubit.subscriptionPlans.length, (index) => Label(text: cubit.subscriptionPlans[index])),
                                  ),
                                  Label(
                                    text: LocaleKeys.pricingPerKm.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  const Sizer(),
                                  DefaultTextFormField(
                                    currentController: cubit.ridePricingPerKmController,
                                    hint: '',
                                    // label: LocaleKeys.pricingPerKm.localize,
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return LocaleKeys.required.localize;
                                      } else {
                                        if ((num.tryParse(v) ?? 0) > (state.costPerKm?.highCostPerKm ?? 0) || (num.tryParse(v) ?? 0) < (state.costPerKm?.lowCostPerKm ?? 0)) {
                                          return context.isArabic
                                              ? "يجب ان يكون السعر للكيلومتر بين ${state.costPerKm?.lowCostPerKm} و ${state.costPerKm?.highCostPerKm}"
                                              : 'Must be between ${state.costPerKm?.lowCostPerKm} and ${state.costPerKm?.highCostPerKm}';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  const Sizer(),
                                  CustomSwitchListTile(
                                    title: Text(
                                      LocaleKeys.nonSmokerDriver.localize,
                                      style: Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400,color:context.isDarkMode ?Colors.white:Colors.black),
                                    ),
                                    value: state.isSmoking ?? false,
                                    onChanged: (value) async {
                                      cubit.onChangeSmokingValue();
                                    },
                                  ),
                                  CustomSwitchListTile(
                                    title: Text(
                                      context.isArabic?"مكيف هواء":"Air Conditioner",
                                      style: Styles.mediumText(fontSize: 65.sp, fontWeight: FontWeight.w400,color:context.isDarkMode ?Colors.white:Colors.black),
                                    ),
                                    value: state.hasAirCondition ?? false,
                                    onChanged: (value) async {
                                      cubit.onChangeAirCondition();
                                    },
                                  )
                                ],
                                if (state.registerType == 'socket' || state.isShipping == true) ...[
                                  const Sizer(),
                                  Label(
                                    text: LocaleKeys.favoriteCity.localize,
                                    style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 30),
                                  ),
                                  RegisterExpansionTile(
                                    title: Label(
                                      text: (state.selectedGov != null && (state.selectedGov?.isNotEmpty ?? false)) ? state.selectedGov ?? '' : LocaleKeys.favoriteCity.localize,
                                    ),
                                    initialTitle: Label(
                                      text: (state.selectedGov != null && (state.selectedGov?.isNotEmpty ?? false)) ? state.selectedGov ?? '' : LocaleKeys.favoriteCity.localize,
                                    ),
                                    onChange: (Widget selectedItem) {
                                      cubit.onSelectGov((selectedItem as Label).text);
                                      // print("Selected Item: ${(selectedItem as Label).text}");
                                    },
                                    length: state.govs?.length ?? 0,
                                    children: List.generate(
                                        state.govs?.length ?? 0, (index) => Label(text: context.isArabic ? (state.govs?[index].nameAr ?? '') : state.govs?[index].nameEn ?? '')),
                                  )
                                ],
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
                            // InkWell(
                            //   onTap: () => Navigator.pop(context),
                            //   child: Container(
                            //     height: 44,
                            //     padding: const EdgeInsets.symmetric(horizontal: 8),
                            //     decoration: BoxDecoration(
                            //       color: AppColors.GREYBG,
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     child: const Icon(
                            //       Icons.arrow_back_ios_new,
                            //       color: AppColors.PRIMARY_COLOR,
                            //     ),
                            //   ),
                            // ),
                            // const Sizer(),
                            InkWell(
                              onTap: () {
                                state.isShipping == true
                                    ? cubit.onLoadingRegister(context, widget.params.subCategoriesId[0], widget.params.isSocket, widget.params.isShipping)
                                    : state.registerType == 'socket'
                                        ? cubit.onRegister(context, widget.params.subCategoriesId, widget.params.isSocket, widget.params.isShipping)
                                        : cubit.onNoSocketRegister(context, widget.params.subCategoriesId[0], widget.params.isSocket, widget.params.isShipping);
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
        ),
      );
    });
  }
}
