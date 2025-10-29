import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/core/widget/icon_and_hint_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/pages/create_ad_dropdown_menu.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/widgets/create_ad_text_form_field.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/custom_header_form.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/categorization_entity.dart';
import '../widgets/ad_dynamic_inputs.dart';

class CreateAdView extends StatefulWidget {
  final CategorizationEntity categorization;

  const CreateAdView({super.key, required this.categorization});

  @override
  State<CreateAdView> createState() => _CreateAdViewState();
}

class _CreateAdViewState extends State<CreateAdView> {
  final FocusNode _focusNode = FocusNode();
  final RegExp _phonePattern = RegExp(
      r'(\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}|' // Common formats: +1 (123) 456-7890, 123-456-7890
      r'\d{10}|' // 10 consecutive digits
      r'\d{3}[\s.-]\d{3}[\s.-]\d{4}|' // 123 456 7890, 123.456.7890
      r'\+\d{10,}' // International format: +1234567890
      );

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var priceController = TextEditingController();
    return BlocConsumer<CreateAdCubit, CreateAdState>(
        listener: (context, state) {
      if (state.isError) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<CreateAdCubit>();
      return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: HomeAppbar(
            isWithBackArrow: true,
            onBackPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<CreateAdCubit, CreateAdState>(
          // buildWhen: (previous, current) => previous.status == current.status,
          builder: (context, state) {
            if (state.status == CreateAdStates.loading) {
              return const CustomLoading();
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Form(
                  key: controller.formState,
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: AppColors.SECONDARY_COLOR,
                    child: ListView(
                      children: [
                        CustomHeaderForm(
                          categorization: widget.categorization,
                        ),

                        const Sizer(
                          height: 20,
                        ),

                        _buildImagePicker(),

                        if (widget.categorization.fromMarriage == false)
                          Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  setState(() {
                                    if (widget.categorization.mainCategory
                                            .nameEn ==
                                        'Dating') {
                                      state.isMale = true;
                                    } else if (widget.categorization.subCategory
                                            .hasAuction ==
                                        true) {
                                      state.isSale = true;
                                    } else {
                                      state.isUser = true;
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (state.isUser == true &&
                                            state.isSale == true &&
                                            state.isMale == true)
                                        ? AppColors.PRIMARY_COLOR
                                        : AppColors.getFillColor(context),
                                    borderRadius: BorderRadius.circular(15),
                                    // border: Border.all(
                                    //     color: (state.isUser == true &&
                                    //             state.isSale == true &&
                                    //             state.isMale == true)
                                    //         ? AppColors.getRedColor(context)
                                    //         : AppColors.getFillColor(context))
                                  ),
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    widget.categorization.mainCategory.nameEn ==
                                            'Dating'
                                        ? LocaleKeys.maleUser.localize
                                        : widget.categorization.subCategory
                                                    .hasAuction ==
                                                true
                                            ? LocaleKeys.sale.localize
                                            : LocaleKeys.user.localize,
                                    style: Styles.mediumText(
                                        color: (state.isUser == true &&
                                                state.isSale == true &&
                                                state.isMale == true)
                                            ? Colors.white
                                            : AppColors.getTextColor(context)),
                                  ),
                                ),
                              )),
                              const Sizer(),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    setState(() {
                                      if (widget.categorization.mainCategory
                                              .nameEn ==
                                          'Dating') {
                                        state.isMale = false;
                                      } else if (widget.categorization
                                              .subCategory.hasAuction ==
                                          true) {
                                        state.isSale = false;
                                        print(state.isSale);
                                        print(state.isSale);
                                      } else {
                                        state.isUser = false;
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: (state.isUser == false ||
                                              state.isSale == false ||
                                              state.isMale == false)
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.getFillColor(context),
                                      borderRadius: BorderRadius.circular(15),
                                      // border: Border.all(
                                      //     color: (state.isUser == false ||
                                      //             state.isSale == false ||
                                      //             state.isMale == false)
                                      //         ? AppColors.getRedColor(context)
                                      //         : AppColors.getFillColor(
                                      //             context))
                                    ),
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      widget.categorization.mainCategory
                                                  .nameEn ==
                                              'Dating'
                                          ? LocaleKeys.femaleUser.localize
                                          : widget.categorization.subCategory
                                                      .hasAuction ==
                                                  true
                                              ? LocaleKeys.rent.localize
                                              : LocaleKeys.provider.localize,
                                      style: Styles.mediumText(
                                          color: (state.isUser == false ||
                                                  state.isSale == false ||
                                                  state.isMale == false)
                                              ? Colors.white
                                              : AppColors.getTextColor(
                                                  context)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const Sizer(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.only(start: 16),
                        //   child: Label(
                        //     text: widget.categorization.fromMarriage == false
                        //         ? LocaleKeys.adTitle.localize
                        //         : LocaleKeys.name.localize,
                        //     style: Styles.mediumText(
                        //       fontSize: 32,
                        //     ),
                        //   ),
                        // ),

                        CreateAdTextFormField(
                          onChanged: (v) {
                            controller.formState.currentState!.validate();
                            controller.title = v;
                          },
                          hintText: widget.categorization.fromMarriage == false
                              ? LocaleKeys.adTitle.localize
                              : LocaleKeys.name.localize,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return LocaleKeys.required.localize;
                            }
                            // ❌ If the whole input is only digits
                            if (RegExp(r'^\d+$').hasMatch(value)) {
                              return context.isArabic
                                  ? 'لا يمكن أن يكون العنوان فقط من الأرقام'
                                  : 'Cannot contain only numbers';
                            }
                            if (_phonePattern.hasMatch(value)) {
                              return context.isArabic
                                  ? 'غير مسموح بالرقم الهاتف. برجاء حذف الرقم الهاتف الموجود'
                                  : 'Phone numbers are not allowed. Please remove any phone number pattern.';
                            }

                            return null;
                          },
                          focusNode: _focusNode,
                        ),
                        // TextFormField(
                        //   maxLines: null,
                        //   onChanged: (v) => controller.title = v,
                        //   style: Styles.headerText(fontSize: 26),
                        //   decoration: InputDecoration(
                        //       fillColor: context.isDarkMode
                        //           ? AppColors.GREY_DARK_COLOR
                        //           : AppColors.LIGHT_COLOR,
                        //       contentPadding: const EdgeInsets.all(5),
                        //       hintText:
                        //           widget.categorization.fromMarriage == false
                        //               ? LocaleKeys.title.localize
                        //               : LocaleKeys.name.localize,
                        //       hintStyle: Styles.mediumText(),
                        //       prefix: Sizer(
                        //         width: 20.w,
                        //       )),
                        //   validator: (value) {
                        //     if ((value == null || value.isEmpty)) {
                        //       return LocaleKeys.required.localize;
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),

                        // Padding(
                        //   padding: const EdgeInsetsDirectional.only(start: 16),
                        //   child: Label(
                        //     text: LocaleKeys.desc.localize,
                        //     style: Styles.mediumText(
                        //       fontSize: 32,
                        //     ),
                        //   ),
                        // ),
                        const Sizer(
                          height: 10,
                        ),
                        CreateAdTextFormField(
                          hintText: LocaleKeys.desc.localize,
                          onChanged: (v) {
                            controller.formState.currentState!.validate();
                            setState(() {
                              controller.description = v;
                            });
                          },
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return LocaleKeys.required.localize;
                            }
                            // ❌ If the whole input is only digits
                            if (RegExp(r'^\d+$').hasMatch(value)) {
                              return context.isArabic
                                  ? 'لا يمكن أن يكون الوصف فقط من الأرقام'
                                  : 'Cannot contain only numbers';
                            }
                            if (_phonePattern.hasMatch(value)) {
                              return context.isArabic
                                  ? 'غير مسموح بالرقم الهاتف. برجاء حذف الرقم الهاتف الموجود'
                                  : 'Phone numbers are not allowed. Please remove any phone number pattern.';
                            }

                            return null;
                          },
                        ),
                        const Sizer(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.only(start: 16),
                        //   child: Label(
                        //     text: LocaleKeys.phone.localize,
                        //     style: Styles.mediumText(fontSize: 32),
                        //   ),
                        // ),
                        PickUpTextFormField(
                          controller: phoneController,
                          onChanged: (v) {
                            controller.formState.currentState!.validate();
                            controller.phone = v;
                          },
                          fillColor: AppColors.getFillColor(context),
                          textColor: AppColors.getTextColor(context),
                          hintText: LocaleKeys.phoneNumber.localize,
                          fieldType: FieldType.phone,
                          validator: (value) => validatorPhone(value),
                          // validator: (value) {
                          //   if ((value == null || value.isEmpty)) {
                          //     return LocaleKeys.required.localize;
                          //   }
                          //   if (!_phonePattern.hasMatch(value)) {
                          //     return LocaleKeys.invalidPhoneNumber.localize;
                          //   }
                          //
                          //   return null;
                          // },
                          // controller: controller,
                        ),
                        /*CreateAdTextFormField(
                          hintText: LocaleKeys.phone.localize,
                          onChanged: (v) => controller.phone = v,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if ((value == null || value.isEmpty)) {
                              return LocaleKeys.required.localize;
                            } else {
                              return null;
                            }
                          },
                        ),*/
                        const Sizer(
                          height: 10,
                        ),
                        // Padding(
                        //   padding: const EdgeInsetsDirectional.only(start: 16),
                        //   child: Label(
                        //     text: LocaleKeys.governorate.localize,
                        //     style: Styles.mediumText(fontSize: 32),
                        //   ),
                        // ),
                        CreateAdDropdownMenu<GovernorateEntity>(
                          value: state.governorate!.isEmpty
                              ? null
                              : state.governorates!
                                  .where((gov) => gov.id == state.governorate)
                                  .toList()[0],
                          hint: LocaleKeys.selectGovernorate.tr(),
                          items: state.governorates
                              ?.map<DropdownMenuItem<GovernorateEntity>>(
                                  (GovernorateEntity government) {
                            return DropdownMenuItem<GovernorateEntity>(
                              value: government,
                              child: Label(
                                text: context.isArabic
                                    ? government.nameAr
                                    : government.nameEn,
                                style: Styles.mediumText(
                                  fontSize: 32,
                                  height: 1.60,
                                  color: AppColors.getTextColor(context),
                                ),
                              ), // Change to city.nameAr for Arabic
                            );
                          }).toList(),
                          onChange: (GovernorateEntity? newValue) {
                            controller.selectGovernorate(newValue?.id ?? '');
                            print("state.governorate${state.governorate}");
                            print("state.city${state.city}");
                            controller.getCities(newValue?.id ?? '');
                          },
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: DropdownButtonFormField<GovernorateEntity>(
                        //     decoration: InputDecoration(
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: context.isDarkMode
                        //                 ? AppColors.LIGHT_COLOR
                        //                 : Colors.black),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: context.isDarkMode
                        //                 ? AppColors.LIGHT_COLOR
                        //                 : Colors.black),
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             color: context.isDarkMode
                        //                 ? AppColors.LIGHT_COLOR
                        //                 : Colors.black),
                        //       ),
                        //       fillColor: context.isDarkMode
                        //           ? Colors.transparent
                        //           : AppColors.LIGHT_COLOR,
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 10, horizontal: 12),
                        //     ),
                        //     hint: Text(
                        //       LocaleKeys.selectGovernorate.tr(),
                        //       style: TextStyle(
                        //         color: context.isDarkMode
                        //             ? AppColors.LIGHT_COLOR
                        //             : AppColors.GREY_DARK_COLOR,
                        //       ),
                        //     ),
                        //     value: null,
                        //     onChanged: (GovernorateEntity? newValue) {
                        //       controller.selectGovernorate(newValue?.id ?? '');
                        //       print("state.governorate${state.governorate}");
                        //       print("state.city${state.city}");
                        //       controller.getCities(newValue?.id ?? '');
                        //     },
                        //     dropdownColor: context.isDarkMode
                        //         ? AppColors.GREY_DARK_COLOR
                        //         : AppColors.LIGHT_COLOR,
                        //     items: state.governorates
                        //         ?.map<DropdownMenuItem<GovernorateEntity>>(
                        //             (GovernorateEntity government) {
                        //       return DropdownMenuItem<GovernorateEntity>(
                        //         value: government,
                        //         child: Text(government
                        //             .nameEn), // Change to city.nameAr for Arabic
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),

                        const Sizer(
                          height: 10,
                        ),
                        state.status == CreateAdStates.loadCities
                            ? const Center(
                                child: CustomCircularProgressIndicator())
                            : state.status == CreateAdStates.loadCitiesSuccess
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsetsDirectional.only(
                                      //       start: 16),
                                      //   child: Label(
                                      //     text: LocaleKeys.city.localize,
                                      //     style: Styles.mediumText(
                                      //         fontSize: 32,
                                      //         color: context.isDarkMode
                                      //             ? AppColors.whiteColor
                                      //             : Colors.black),
                                      //   ),
                                      // ),
                                      CreateAdDropdownMenu<CityEntity>(
                                        value: state.city == null ||
                                                state.city!.isEmpty
                                            ? null
                                            : state.cities!
                                                .where((city) =>
                                                    city.id == state.city)
                                                .toList()[0],
                                        hint: LocaleKeys.selectCity.tr(),
                                        items: state.cities
                                            ?.map<DropdownMenuItem<CityEntity>>(
                                                (CityEntity city) {
                                          return DropdownMenuItem<CityEntity>(
                                            value: city,
                                            child: Label(
                                              text: context.isArabic
                                                  ? city.nameAr
                                                  : city.nameEn,
                                              // color: Colors.black,
                                              style: Styles.mediumText(
                                                fontSize: 32,
                                                height: 1.60,
                                                color: AppColors.getTextColor(
                                                    context),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChange: (CityEntity? newValue) {
                                          print(newValue?.id);
                                          controller
                                              .selectCity(newValue?.id ?? '');
                                          print(
                                              "state.governorate${state.governorate}");
                                          print("state.city${state.city}");
                                        },
                                      ),
                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   child:
                                      //       DropdownButtonFormField<CityEntity>(
                                      //     decoration: InputDecoration(
                                      //       focusedBorder: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //             color: context.isDarkMode
                                      //                 ? AppColors.LIGHT_COLOR
                                      //                 : Colors.black),
                                      //       ),
                                      //       enabledBorder: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //             color: context.isDarkMode
                                      //                 ? AppColors.LIGHT_COLOR
                                      //                 : Colors.black),
                                      //       ),
                                      //       border: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //             color: context.isDarkMode
                                      //                 ? AppColors.LIGHT_COLOR
                                      //                 : Colors.black),
                                      //       ),
                                      //       fillColor: context.isDarkMode
                                      //           ? Colors.transparent
                                      //           : AppColors.LIGHT_COLOR,
                                      //       contentPadding:
                                      //           const EdgeInsets.symmetric(
                                      //               vertical: 10, horizontal: 12),
                                      //     ),
                                      //     hint: Text(
                                      //       LocaleKeys.selectCity.tr(),
                                      //       style: TextStyle(
                                      //         color: context.isDarkMode
                                      //             ? AppColors.LIGHT_COLOR
                                      //             : AppColors.GREY_DARK_COLOR,
                                      //       ),
                                      //     ),
                                      //     value: null,
                                      //     onChanged: (CityEntity? newValue) {
                                      //       print(newValue?.id);
                                      //       controller
                                      //           .selectCity(newValue?.id ?? '');
                                      //       print(
                                      //           "state.governorate${state.governorate}");
                                      //       print("state.city${state.city}");
                                      //     },
                                      //     dropdownColor: context.isDarkMode
                                      //         ? AppColors.GREY_DARK_COLOR
                                      //         : AppColors.LIGHT_COLOR,
                                      //     items: state.cities
                                      //         ?.map<DropdownMenuItem<CityEntity>>(
                                      //             (CityEntity city) {
                                      //       return DropdownMenuItem<CityEntity>(
                                      //         value: city,
                                      //         child: Text(city
                                      //             .nameEn), // Change to city.nameAr for Arabic
                                      //       );
                                      //     }).toList(),
                                      //   ),
                                      // ),
                                      const Sizer(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                        if (widget.categorization.fromMarriage == false) ...[
                          // Padding(
                          //   padding: const EdgeInsetsDirectional.only(start: 16),
                          //   child: Label(
                          //     text: state.isPrice == true
                          //         ? LocaleKeys.price.localize
                          //         : LocaleKeys.salary.localize,
                          //     style: Styles.mediumText(fontSize: 32),
                          //   ),
                          // ),
                          PickUpTextFormField(
                            controller: priceController,
                            onChanged: (v) {
                              controller.formState.currentState!.validate();
                              controller.price = v;
                            },
                            fillColor: AppColors.getFillColor(context),
                            textColor: AppColors.getTextColor(context),
                            hintText: state.isPrice == true
                                ? LocaleKeys.price.localize
                                : LocaleKeys.salary.localize,
                            fieldType: FieldType.number,
                            validator: (value) {
                              if ((value == null || value.isEmpty)) {
                                return LocaleKeys.required.localize;
                              } else {
                                return null;
                              }
                            },
                            // validator: (value) {
                            //   if ((value == null || value.isEmpty)) {
                            //     return LocaleKeys.required.localize;
                            //   }
                            //   if (!_phonePattern.hasMatch(value)) {
                            //     return LocaleKeys.invalidPhoneNumber.localize;
                            //   }
                            //
                            //   return null;
                            // },
                            // controller: controller,
                          ),
                          /* CreateAdTextFormField(
                            onChanged: (v) => controller.price = v,
                            hintText: state.isPrice == true
                                ? LocaleKeys.price.localize
                                : LocaleKeys.salary.localize,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if ((value == null || value.isEmpty)) {
                                return LocaleKeys.required.localize;
                              } else {
                                return null;
                              }
                            },
                          ),*/
                          // TextFormField(
                          //   maxLines: 1,
                          //   keyboardType: TextInputType.number,
                          //   onChanged: (v) => controller.price = v,
                          //   style: Styles.headerText(fontSize: 26),
                          //   decoration: InputDecoration(
                          //       fillColor: context.isDarkMode
                          //           ? AppColors.GREY_DARK_COLOR
                          //           : AppColors.LIGHT_COLOR,
                          //       contentPadding: const EdgeInsets.all(5),
                          //       hintText: state.isPrice == true
                          //           ? LocaleKeys.price.localize
                          //           : LocaleKeys.salary.localize,
                          //       ),
                          //   validator: (value) {
                          //     if ((value == null || value.isEmpty)) {
                          //       return LocaleKeys.required.localize;
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          // )
                        ],
                        const Sizer(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final property = state.adProperties![index];

                            return AdDynamicInputWidget(
                              formKey: controller.formState,
                              property: property,
                              onChanged: (SelectionEntity v) =>
                                  controller.onChanged(v: v, index: index),
                              onTextChanged: (String v) =>
                                  controller.onTextChanged(v: v, index: index),
                              selectedProp: '',
                              textInputAction:
                                  property.nameEn == 'family name' ||
                                          property.nameAr == 'اسم العائلة'
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                            );
                          },
                          // separatorBuilder: (context, index) => const Sizer(),
                          shrinkWrap: true,
                          itemCount: state.adProperties?.length ?? 0,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        state.isLoadingCreateAd
                            ? const Center(
                                child: CustomCircularProgressIndicator())
                            : Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label:
                                          LocaleKeys.publish_permiun.localize,
                                      backColor: AppColors.getRedColor(context),
                                      style: Styles.headerText(
                                        color: AppColors.getReversedTextColor(
                                            context),
                                        fontSize: 28,
                                      ),
                                      height: 44,
                                      onPressed: () {
                                        ManageVibration.vibrate();
                                        controller.createAd(
                                          categorize: widget.categorization,
                                          context: context,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: AppButton(
                                      label: LocaleKeys.publish.localize,
                                      backColor:
                                          AppColors.getButtonPrimaryColor(
                                              context),
                                      style: Styles.headerText(
                                        color: AppColors.getReversedTextColor(
                                            context),
                                        fontSize: 28,
                                      ),
                                      height: 44,
                                      onPressed: () {
                                        ManageVibration.vibrate();
                                        controller.createAd(
                                          categorize: widget.categorization,
                                          context: context,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 16,
                        ),
                        // DefaultButton(
                        //   label: LocaleKeys.publish.localize,
                        //   onPressed: () {
                        //     controller.createAd(
                        //       categorize: widget.categorization,
                        //       context: context,
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print("/v1/ads/PropsByMainCategoryId/62c8be568e28a58a3edf5f1d");

    // Map old fitness category ID to new one
    // String getCategoryId() {
    //   String id = widget.categorization.subCategory.id;

    //   // Replace old fitness category ID with new one
    //   if (id == '62c8b5a29332225799fe3348') {
    //     return '62c8be568e28a58a3edf5f1d';
    //   }
    //   return id;
    // }

    context.read<CreateAdCubit>().loadData(
        subCategoryId: widget.categorization.fromMarriage == false
            ? widget.categorization.subCategory.id
            : widget.categorization.subCategory.id,
        fromMarriage: widget.categorization.fromMarriage ?? false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  Widget _buildImagePicker() {
    return BlocBuilder<CreateAdCubit, CreateAdState>(
      builder: (context, state) {
        final controller = context.read<CreateAdCubit>();
        return Column(
          children: [
            InkWell(
              onTap: () {
                ManageVibration.vibrate();
                if ((state.images?.length ?? 0) < 20) {
                  controller.uploadImage(
                    subCategoryId: widget.categorization.subCategory.id,
                    context: context,
                  );
                } else {
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? "لا يمكنك إضافة أكثر من 20 صور"
                          : "You can not add more than 20 images");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.getFillColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // height: kToolbarHeight * 3,
                // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(5)),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // if (state.isImageUploading)
                    //   const CustomCircularProgressIndicator(),
                    // if (!state.isImageUploading)
                    SvgPicture.asset(
                      Assets.image2Icon,
                      color: context.isDarkMode ? AppColors.whiteColor : null,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // if (controller.loadImage==true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          size: 30,
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.c0B1035,
                        ),
                        const Sizer(
                          width: 8,
                        ),
                        Label(
                          text: LocaleKeys.uploadImage.localize,
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : const Color(0xff0B1035),
                          ),
                        ),
                      ],
                    ),
                    const Sizer(
                      height: 8,
                    ),
                    IconAndHintWidget(
                      text: LocaleKeys.addImagesDesc.localize,
                      textStyle: Styles.mediumText(
                        fontSize: 24,
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : const Color(0xff717171),
                      ),
                    ),
                    // Label(
                    //   text: LocaleKeys.addImagesDesc.localize,
                    //   style: Styles.mediumText(
                    //     color: context.isDarkMode
                    //         ? AppColors.LIGHT_COLOR
                    //         : AppColors.GREY_DARK_COLOR,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
            const Sizer(
              height: 20,
            ),
            if (state.images?.isNotEmpty ?? false)
              SizedBox(
                height: 80,
                child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final image = state.images![index];
                      final file = state.files![index];
                      return Container(
                        height: 60,
                        width: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          alignment: AlignmentDirectional.topStart,
                          children: [
                            Positioned.fill(
                                child: Image.file(
                              fit: BoxFit.cover,
                              File(file.path),
                            )),
                            PositionedDirectional(
                              start: 5.w,
                              top: 0,
                              child: IconAppButton(
                                width: 35.w,
                                height: 35.h,
                                icon: Icons.close_sharp,
                                color: Colors.red,
                                backColor: Colors.white,
                                size: 25.w,
                                isCircle: true,
                                onPressed: () => showAreYouSure(
                                  context: context,
                                  title: LocaleKeys.alert.localize,
                                  subTitle: LocaleKeys
                                      .areYouSureYouWantToRemoveThisImage
                                      .localize,
                                  action: () {
                                    controller.removeImage(image: image);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.images?.length ?? 0),
              )
          ],
        );
      },
    );
  }
}
