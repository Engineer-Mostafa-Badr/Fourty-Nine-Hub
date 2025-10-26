import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/pages/create_ad_dropdown_menu.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/widgets/create_ad_text_form_field.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class AdDynamicInputWidget extends StatefulWidget {
  final AdPropertiesEntity property;
  final Function(SelectionEntity) onChanged;
  final Function(String) onTextChanged;
  final String selectedProp;
  final GlobalKey<FormState> formKey;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  const AdDynamicInputWidget({
    super.key,
    required this.property,
    required this.onChanged,
    required this.onTextChanged,
    required this.selectedProp,
    required this.formKey,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<AdDynamicInputWidget> createState() => _AdDynamicInputWidgetState();
}

class _AdDynamicInputWidgetState extends State<AdDynamicInputWidget> {
  SelectionEntity? value;
  String? customValue;
  TextEditingController? customValueController;

  @override
  void initState() {
    if (widget.property.values.isNotEmpty) {
      value = widget.property.values.first;
    }
    customValueController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode?.requestFocus();
    });

    super.initState();
  }

  @override
  void dispose() {
    customValueController?.dispose();
    super.dispose();
  }

  // Check if this field should be hidden based on other field selections
  bool _shouldHideField(CreateAdState state) {
    // Check if this is a polygamy field and if religion is Christian
    final isPolygamyField =
        widget.property.nameAr.toLowerCase().contains('تعدد') ||
            widget.property.nameAr.toLowerCase().contains('زواج') ||
            widget.property.nameEn.toLowerCase().contains('polygamy') ||
            widget.property.nameEn.toLowerCase().contains('marriage');

    if (isPolygamyField &&
        state.adProperties != null &&
        state.selections != null) {
      // Find religion field and check if it's Christian
      for (int i = 0; i < state.adProperties!.length; i++) {
        final property = state.adProperties![i];
        final isReligionField = property.nameAr.toLowerCase().contains('دين') ||
            property.nameAr.toLowerCase().contains('ديانة') ||
            property.nameEn.toLowerCase().contains('religion');

        if (isReligionField && i < state.selections!.length) {
          final religionSelection = state.selections![i];
          final isChristian =
              religionSelection.nameAr.toLowerCase().contains('مسيحي') ||
                  religionSelection.nameEn.toLowerCase().contains('christian');

          if (isChristian) {
            return true; // Hide polygamy field for Christians
          }
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAdCubit, CreateAdState>(
      builder: (context, state) {
        // Hide the field if conditions are met
        if (_shouldHideField(state)) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            if (widget.property.adPropertyType.isText) ...[
              const Sizer(),
              _buildTextFieldWidget()
            ],
            if (widget.property.adPropertyType.isSelect) ...[
              const Sizer(),
              _buildSelectFieldWidget()
            ],
            if (widget.property.adPropertyType.isNumber) ...[
              const Sizer(),
              _buildNumberFieldWidget()
            ],
            if (widget.property.adPropertyType.isDropDown) ...[
              const Sizer(),
              _buildDropDownWidget()
            ],
          ],
        );
      },
    );
  }

  String formatText(String input) {
    // Handle camelCase by adding spaces before uppercase letters
    String processedInput = input.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Split by dash, underscore, or space
    return processedInput
        .split(RegExp(r'[-_\s]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String _getDisplayLabel() {
    // Check if this is a gold grams field and customize the label
    final isGoldGramsField =
        widget.property.nameAr.toLowerCase().contains('جرامات') ||
            widget.property.nameAr.toLowerCase().contains('جرام') ||
            widget.property.nameAr.toLowerCase().contains('دهب') ||
            widget.property.nameAr.toLowerCase().contains('ذهب') ||
            widget.property.nameEn.toLowerCase().contains('grams') ||
            widget.property.nameEn.toLowerCase().contains('gold');

    if (isGoldGramsField) {
      return getLang() == 'ar' ? 'عدد جرامات الذهب' : 'Number of Gold Grams';
    }

    // Check if this is a location field and customize the label for health category
    final isLocationField =
        widget.property.nameAr.toLowerCase().contains('موقع') ||
            widget.property.nameAr.toLowerCase().contains('عنوان') ||
            widget.property.nameAr.toLowerCase().contains('العنوان') ||
            widget.property.nameEn.toLowerCase().contains('location') ||
            widget.property.nameEn.toLowerCase().contains('address');

    if (isLocationField) {
      return getLang() == 'ar' ? 'عنوان العياده' : 'Clinic Address';
    }

    // Check if this is a qualification field and customize the label
    final isQualificationField =
        widget.property.nameAr.toLowerCase().contains('مؤهل') ||
            widget.property.nameAr.toLowerCase().contains('ترخيص') ||
            widget.property.nameEn.toLowerCase().contains('qualification') ||
            widget.property.nameEn.toLowerCase().contains('license');

    if (isQualificationField) {
      return getLang() == 'ar' ? 'المؤهل' : 'Qualification';
    }

    // Default behavior for other fields
    return getLang() == 'ar'
        ? widget.property.nameAr
        : formatText(widget.property.nameEn);
  }

  Widget _buildTextFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            bottom: 8,
            start: 15,
          ),
          child: Label(
            text: _getDisplayLabel(),
            style: Styles.mediumText(
                fontSize: 32, color: AppColors.getTextColor(context)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        CreateAdTextFormField(
          hintText: _getDisplayLabel(),
          onChanged: (v) {
            widget.formKey.currentState!.validate();
            widget.onTextChanged(v);
          },
          keyboardType: TextInputType.text,
          validator: (value) {
            // جعل حقل التفاصيل الإضافية غير مطلوب
            final isAdditionalDetailsField = widget.property.nameAr
                    .toLowerCase()
                    .contains('تفاصيل') ||
                widget.property.nameAr.toLowerCase().contains('إضافية') ||
                widget.property.nameAr.toLowerCase().contains('زائدة') ||
                widget.property.nameAr.toLowerCase().contains('أخرى') ||
                widget.property.nameEn.toLowerCase().contains('additional') ||
                widget.property.nameEn.toLowerCase().contains('extra') ||
                widget.property.nameEn.toLowerCase().contains('other');

            if (isAdditionalDetailsField) {
              return null; // لا تطلب هذا الحقل
            }

            if ((value == null || value.isEmpty)) {
              return LocaleKeys.required.localize;
            } else {
              return null;
            }
          },
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildDropDownWidget() {
    // التحقق من أن هذا حقل مؤهل دراسي أو تخصص
    final isEducationField =
        widget.property.nameAr.toLowerCase().contains('مؤهل') ||
            widget.property.nameAr.toLowerCase().contains('تعليم') ||
            widget.property.nameAr.toLowerCase().contains('تخصص') ||
            widget.property.nameAr.toLowerCase().contains('دراسي') ||
            widget.property.nameEn.toLowerCase().contains('education') ||
            widget.property.nameEn.toLowerCase().contains('qualification') ||
            widget.property.nameEn.toLowerCase().contains('specialization');

    // التحقق من اختيار "تخصص آخر" أو "آخر"
    final isOtherSelected = value != null &&
        (value!.nameAr.toLowerCase().contains('آخر') ||
            value!.nameAr.toLowerCase().contains('أخرى') ||
            value!.nameAr.toLowerCase().contains('تخصص آخر') ||
            value!.nameEn.toLowerCase().contains('other') ||
            value!.nameEn.toLowerCase().contains('else'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr.replaceAll('_', ' ')
                : formatText(widget.property.nameEn),
            style: Styles.mediumText(
                fontSize: 32, color: AppColors.getTextColor(context)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        CreateAdDropdownMenu<SelectionEntity>(
          hint: getLang() == 'ar' ? value?.nameAr ?? '' : value?.nameEn ?? '',
          items: widget.property.values
              .map<DropdownMenuItem<SelectionEntity>>((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                        context.isArabic ? e.nameAr : formatText(e.nameEn)),
                  ))
              .toList(),
          onChange: (SelectionEntity? newValue) {
            widget.formKey.currentState!.validate();
            if (newValue != null) {
              value = newValue;
              // مسح الحقل المخصص عند تغيير الاختيار
              customValue = null;
              customValueController?.clear();
              widget.onChanged(newValue);
              setState(() {});
            }
          },
          value: value,
        ),
        // إضافة حقل النص المخصص عند اختيار "تخصص آخر"
        if (isEducationField && isOtherSelected) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: Label(
              text: context.isArabic
                  ? 'يرجى كتابة التخصص'
                  : 'Please specify the specialization',
              style: Styles.mediumText(
                  fontSize: 32, color: AppColors.getTextColor(context)),
            ),
          ),
          const SizedBox(height: 4),
          CreateAdTextFormField(
            hintText: context.isArabic
                ? 'اكتب التخصص هنا'
                : 'Enter specialization here',
            onChanged: (v) {
              widget.formKey.currentState!.validate();
              customValue = v;
              // إنشاء SelectionEntity مخصص مع القيمة المدخلة
              if (v.isNotEmpty) {
                final customSelection = SelectionEntity(
                  nameAr: v,
                  nameEn: v,
                );
                widget.onChanged(customSelection);
              }
            },
            keyboardType: TextInputType.text,
            validator: (value) {
              if (isOtherSelected && (value == null || value.isEmpty)) {
                return context.isArabic
                    ? 'يرجى كتابة التخصص'
                    : 'Please specify the specialization';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNumberFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Label(
            text: _getDisplayLabel(),
            style: Styles.mediumText(
                fontSize: 32,
                color:
                    context.isDarkMode ? AppColors.whiteColor : Colors.black),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        CreateAdTextFormField(
          onChanged: (String v) {
            widget.formKey.currentState!.validate();
            widget.onTextChanged(v);
          },
          hintText: _getDisplayLabel(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            // جعل حقل التفاصيل الإضافية غير مطلوب
            final isAdditionalDetailsField = widget.property.nameAr
                    .toLowerCase()
                    .contains('تفاصيل') ||
                widget.property.nameAr.toLowerCase().contains('إضافية') ||
                widget.property.nameAr.toLowerCase().contains('زائدة') ||
                widget.property.nameAr.toLowerCase().contains('أخرى') ||
                widget.property.nameEn.toLowerCase().contains('additional') ||
                widget.property.nameEn.toLowerCase().contains('extra') ||
                widget.property.nameEn.toLowerCase().contains('other');

            if (isAdditionalDetailsField) {
              return null; // لا تطلب هذا الحقل
            }

            if ((value == null || value.isEmpty)) {
              return LocaleKeys.required.localize;
            } else {
              // Check if this is an age field and validate age limits
              final isAgeField =
                  widget.property.nameAr.toLowerCase().contains('العمر') ||
                      widget.property.nameEn.toLowerCase().contains('age');

              if (isAgeField) {
                final age = int.tryParse(value);
                if (age == null) {
                  return context.isArabic
                      ? 'يرجى إدخال عمر صحيح'
                      : 'Please enter a valid age';
                }
                if (age > 100) {
                  return context.isArabic
                      ? 'العمر لا يمكن أن يكون أكثر من 100 سنة'
                      : 'Age cannot be more than 100 years';
                }
                if (age < 1) {
                  return context.isArabic
                      ? 'العمر لا يمكن أن يكون أقل من سنة واحدة'
                      : 'Age cannot be less than 1 year';
                }
              }

              // Check if this is a years of experience field and validate limits
              final isExperienceField = widget.property.nameAr
                      .toLowerCase()
                      .contains('سنوات') ||
                  widget.property.nameAr.toLowerCase().contains('خبرة') ||
                  widget.property.nameEn.toLowerCase().contains('experience') ||
                  widget.property.nameEn.toLowerCase().contains('years');

              if (isExperienceField) {
                final experienceYears = int.tryParse(value);
                if (experienceYears == null) {
                  return context.isArabic
                      ? 'يرجى إدخال عدد سنوات صحيح'
                      : 'Please enter a valid number of years';
                }
                if (experienceYears > 50) {
                  return context.isArabic
                      ? 'عدد سنوات الخبرة لا يمكن أن يكون أكثر من 50 سنة'
                      : 'Years of experience cannot be more than 50 years';
                }
                if (experienceYears < 0) {
                  return context.isArabic
                      ? 'عدد سنوات الخبرة لا يمكن أن يكون سالباً'
                      : 'Years of experience cannot be negative';
                }
              }

              // Check if this is a success cases field and validate limits
              final isSuccessCasesField = widget.property.nameAr
                      .toLowerCase()
                      .contains('حالات') ||
                  widget.property.nameAr.toLowerCase().contains('نجاح') ||
                  widget.property.nameAr.toLowerCase().contains('نجح') ||
                  widget.property.nameEn.toLowerCase().contains('success') ||
                  widget.property.nameEn.toLowerCase().contains('cases');

              if (isSuccessCasesField) {
                final successCases = int.tryParse(value);
                if (successCases == null) {
                  return context.isArabic
                      ? 'يرجى إدخال عدد حالات صحيح'
                      : 'Please enter a valid number of cases';
                }
                if (successCases > 150) {
                  return context.isArabic
                      ? 'عدد حالات النجاح لا يمكن أن يكون أكثر من 150 حالة'
                      : 'Number of success cases cannot be more than 150 cases';
                }
                if (successCases < 0) {
                  return context.isArabic
                      ? 'عدد حالات النجاح لا يمكن أن يكون سالباً'
                      : 'Number of success cases cannot be negative';
                }
              }

              // Check if this is a gold grams field and validate limits
              final isGoldGramsField =
                  widget.property.nameAr.toLowerCase().contains('جرامات') ||
                      widget.property.nameAr.toLowerCase().contains('جرام') ||
                      widget.property.nameAr.toLowerCase().contains('دهب') ||
                      widget.property.nameAr.toLowerCase().contains('ذهب') ||
                      widget.property.nameEn.toLowerCase().contains('grams') ||
                      widget.property.nameEn.toLowerCase().contains('gold');

              if (isGoldGramsField) {
                final goldGrams = int.tryParse(value);
                if (goldGrams == null) {
                  return context.isArabic
                      ? 'يرجى إدخال عدد جرامات صحيح'
                      : 'Please enter a valid number of grams';
                }
                if (goldGrams > 1000) {
                  return context.isArabic
                      ? 'عدد جرامات الذهب لا يمكن أن يكون أكثر من 1000 جرام'
                      : 'Number of gold grams cannot be more than 1000 grams';
                }
                if (goldGrams < 1) {
                  return context.isArabic
                      ? 'عدد جرامات الذهب لا يمكن أن يكون أقل من 1 جرام'
                      : 'Number of gold grams cannot be less than 1 gram';
                }
              }

              // Check if this is a height or weight field and validate limits
              final isHeightField =
                  widget.property.nameAr.toLowerCase().contains('الطول') ||
                      widget.property.nameEn.toLowerCase().contains('height');
              final isWeightField =
                  widget.property.nameAr.toLowerCase().contains('الوزن') ||
                      widget.property.nameEn.toLowerCase().contains('weight');

              if (isHeightField || isWeightField) {
                final numericValue = int.tryParse(value);
                if (numericValue == null) {
                  return context.isArabic
                      ? 'يرجى إدخال قيمة صحيحة'
                      : 'Please enter a valid value';
                }
                if (numericValue > 200) {
                  final fieldName = isHeightField
                      ? (context.isArabic ? 'الطول' : 'Height')
                      : (context.isArabic ? 'الوزن' : 'Weight');
                  return context.isArabic
                      ? '$fieldName لا يمكن أن يكون أكثر من 200'
                      : '$fieldName cannot be more than 200';
                }
                if (numericValue < 1) {
                  final fieldName = isHeightField
                      ? (context.isArabic ? 'الطول' : 'Height')
                      : (context.isArabic ? 'الوزن' : 'Weight');
                  return context.isArabic
                      ? '$fieldName لا يمكن أن يكون أقل من 1'
                      : '$fieldName cannot be less than 1';
                }
              }

              return null;
            }
          },
        ),
        // FormTextField(
        //   label: getLang() == 'ar'
        //       ? widget.property.nameAr
        //       : widget.property.nameEn,
        //   type: TextInputType.number,
        //   height: kToolbarHeight * .8,
        //   hint: 'Type here',
        //   action: (String v) => widget.onTextChanged(v),
        // ),
      ],
    );
  }

  Widget _buildSelectFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : formatText(widget.property.nameEn),
            style: Styles.mediumText(
                fontSize: 32,
                color: context.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.black),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.4),
            itemCount: widget.property.values.length,
            itemBuilder: (context, index) => ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    widget.formKey.currentState!.validate();
                    widget.onChanged(widget.property.values[index]);
                    value = widget.property.values[index];
                    setState(() {});
                  },
                  child: Container(
                    height: 42,
                    width: MediaQuery.of(context).size.width * 0.52,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    // margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.getFillColor(context),
                      border: value == widget.property.values[index]
                          ? Border.all(
                              color: AppColors.SECONDARY_COLOR_DARK2,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Label(
                      text: getLang() == 'ar'
                          ? widget.property.values[index].nameAr
                          : widget.property.values[index].nameEn,
                      style: Styles.mediumText(
                          fontSize: 28,
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.black),
                    ),
                  ),
                )),
        // Row(
        //   spacing: 8,
        //   children: widget.property.values.map((e) {
        //     return Expanded(
        //       child: InkWell(
        //         onTap: () {
        //           widget.onChanged(e);
        //           value = e;
        //           setState(() {});
        //         },
        //         child: Container(
        //           height: 42,
        //           alignment: Alignment.center,
        //           padding: const EdgeInsets.all(5),
        //           // margin: const EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //             color: context.isDarkMode?AppColors.GREY_DARK_COLOR:const Color(0xffF5F5F5),
        //             border: value == e
        //                 ? Border.all(
        //                     color: AppColors.SECONDARY_COLOR_DARK2,
        //                   )
        //                 : null,
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           child: Label(
        //             text: getLang() == 'ar' ? e.nameAr : e.nameEn,
        //             style: Styles.mediumText(fontSize: 32,color: context.isDarkMode?AppColors.whiteColor:AppColors.black),
        //           ),
        //         ),
        //       ),
        //     );
        //   }).toList(),
        // ),
        // RichText(
        //     text: TextSpan(
        //         children: widget.property.values.map((e) {
        //   return WidgetSpan(
        //       child: InkWell(
        //     onTap: () {
        //       widget.onChanged(e);
        //       value = e;
        //       setState(() {});
        //     },
        //     child: Container(
        //       padding: const EdgeInsets.all(5),
        //       margin: const EdgeInsets.all(5),
        //       decoration: BoxDecoration(
        //         border: Border.all(
        //             color:
        //                 value == e ? AppColors.SECONDARY_COLOR : Colors.grey),
        //         borderRadius: BorderRadius.circular(5),
        //       ),
        //       child: Label(
        //         text: getLang() == 'ar' ? e.nameAr : e.nameEn,
        //       ),
        //     ),
        //   ));
        // }).toList())),
      ],
    );
  }
}
