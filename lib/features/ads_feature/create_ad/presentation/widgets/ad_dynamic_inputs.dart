import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
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
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  const AdDynamicInputWidget({
    super.key,
    required this.property,
    required this.onChanged,
    required this.onTextChanged,
    required this.selectedProp,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<AdDynamicInputWidget> createState() => _AdDynamicInputWidgetState();
}

class _AdDynamicInputWidgetState extends State<AdDynamicInputWidget> {
  SelectionEntity? value;
  @override
  void initState() {
    if (widget.property.values.isNotEmpty) {
      value = widget.property.values.first;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode?.requestFocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
            style: Styles.mediumText(
                fontSize: 32, color: AppColors.getTextColor(context)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        CreateAdTextFormField(
          hintText: getLang() == 'ar'
              ? widget.property.nameAr
              : widget.property.nameEn,
          onChanged: (v) => widget.onTextChanged(v),
          keyboardType: TextInputType.text,
          validator: (value) {
            if ((value == null || value.isEmpty)) {
              return LocaleKeys.required.localize;
            } else {
              return null;
            }
          },
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
        ),
        // TextFormField(
        //   maxLines: null,
        //   onChanged: (v) => widget.onTextChanged(v),
        //   style: Styles.headerText(fontSize: 26),
        //   decoration: InputDecoration(
        //       fillColor: Colors.white,
        //       contentPadding: const EdgeInsets.all(5),
        //       hintText: getLang() == 'ar'
        //           ? widget.property.nameAr
        //           : widget.property.nameEn,
        //       hintStyle: Styles.mediumText(),
        //       prefix: Sizer(
        //         width: 20.w,
        //       )),
        //   // keyboardType: TextInputType.number,
        //   validator: (value) {
        //     if ((value == null || value.isEmpty)) {
        //       return LocaleKeys.required.localize;
        //     } else {
        //       return null;
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget _buildDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr.replaceAll('_', ' ')
                : widget.property.nameEn.replaceAll('_', ' '),
            style: Styles.mediumText(
                fontSize: 32, color: AppColors.getTextColor(context)),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        CreateAdDropdownMenu<SelectionEntity>(
          hint: getLang() == 'ar' ? value?.nameAr ?? '' : value?.nameEn ?? '',
          // items: state.cities
          //                 ?.map<DropdownMenuItem<CityEntity>>(
          //                     (CityEntity city) {
          //               return DropdownMenuItem<CityEntity>(
          //                 value: city,
          //                 child: Text(city.nameEn),
          //               );
          //             }).toList(),
          items: widget.property.values
              .map<DropdownMenuItem<SelectionEntity>>((e) => DropdownMenuItem(
                    value: e,
                    child: Text(context.isArabic ? e.nameAr : e.nameEn),
                  ))
              .toList(),
          onChange: (SelectionEntity? newValue) {
            if (newValue != null) {
              value = newValue;
              widget.onChanged(newValue);
              setState(() {});
            }
          },
          value: value,
        ),
        // InkWell(
        //   onTap: () {
        //     bottomSheet(
        //         context: context,
        //         isScrollControlled: true,
        //         widget: _buildOptionsSheet(
        //             action: (SelectionEntity v) {
        //               widget.onChanged(v);
        //               context.pop();
        //             },
        //             values: widget.property.values));
        //   },
        //   child: Container(
        //     width: double.infinity,
        //     padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5),
        //     // margin: EdgeInsets.all(5),
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.black),
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: Label(
        //               text: getLang() == 'ar'
        //                   ? value?.nameAr ?? ''
        //                   : value?.nameEn ?? ''),
        //         ),
        //         const Icon(Icons.arrow_drop_down)
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildOptionsSheet({
  //   required Function(SelectionEntity v) action,
  //   required List<SelectionEntity> values,
  // }) {
  //   return CustomScaffold(
  //     appBar: BackAppBar(
  //       label: LocaleKeys.select.localize,
  //     ),
  //     body: ListView.builder(
  //         itemCount: values.length,
  //         itemBuilder: (context, index) {
  //           final v = values[index];
  //           return ListTile(
  //             onTap: () {
  //               action(v);
  //               value = v;
  //               setState(() {});
  //             },
  //             title: Label(text: getLang() == 'ar' ? v.nameAr : v.nameEn),
  //           );
  //         }),
  //   );
  // }

  Widget _buildNumberFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
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
          onChanged: (String v) => widget.onTextChanged(v),
          hintText: getLang() == 'ar'
              ? widget.property.nameAr
              : widget.property.nameEn,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if ((value == null || value.isEmpty)) {
              return LocaleKeys.required.localize;
            } else {
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
                : widget.property.nameEn,
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
