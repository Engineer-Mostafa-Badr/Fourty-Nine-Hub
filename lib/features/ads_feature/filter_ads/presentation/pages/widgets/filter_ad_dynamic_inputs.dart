import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class FilterAdDynamicInputWidget extends StatefulWidget {
  final AdPropertiesEntity property;
  final Function(SelectionEntity) onChanged;
  final Function(String, bool, String) onTextChanged;

  const FilterAdDynamicInputWidget(
      {super.key,
      required this.property,
      required this.onChanged,
      required this.onTextChanged});

  @override
  State<FilterAdDynamicInputWidget> createState() =>
      _FilterAdDynamicInputWidgetState();
}

class _FilterAdDynamicInputWidgetState
    extends State<FilterAdDynamicInputWidget> {
  SelectionEntity? value;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    if (widget.property.values.isNotEmpty) {
      value = widget.property.values.first;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.property.adPropertyType.isText) _buildTextFieldWidget(),
        if (widget.property.adPropertyType.isSelect) _buildSelectFieldWidget(),
        if (widget.property.adPropertyType.isNumber) _buildNumberFieldWidget(),
        if (widget.property.adPropertyType.isDropDown) _buildDropDownWidget(),
      ],
    );
  }

  Widget _buildTextFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
            style: Styles.mediumText(fontSize: 32),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 42,
            child: TextFormField(
              maxLines: null,

              onChanged: (v) {
                widget.onTextChanged(v, true, widget.property.type);
              },
              style: Styles.mediumText(
                  fontSize: 32, color: AppColors.getTextColor(context)),
              decoration: InputDecoration(
                fillColor: AppColors.getFillColor(context),
                filled: true,
                contentPadding: const EdgeInsetsDirectional.only(start: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: Styles.mediumText(
                    fontSize: 32, color: AppColors.getTextColor(context)),
                hintText: getLang() == 'ar'
                    ? widget.property.nameAr
                    : widget.property.nameEn,
                // prefix: Sizer(
                //   width: 20.w,
                // ),
              ),
              // keyboardType: TextInputType.number,
              validator: (value) {
                if ((value == null || value.isEmpty)) {
                  return LocaleKeys.required.localize;
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
            style: Styles.mediumText(fontSize: 32),
          ),
          const SizedBox(
            height: 4,
          ),
          DropdownButtonHideUnderline(
            child: Container(
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.getFillColor(context),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: AppColors.getFillColor(context),
                ),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<SelectionEntity>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    menuMaxHeight: 300,
                    elevation: 2,
                    dropdownColor: AppColors.getFillColor(context),
                    borderRadius: BorderRadius.circular(15),
                    itemHeight: 50,
                    underline: Container(),
                    onChanged: (SelectionEntity? newValue) {
                      if (newValue != null) {
                        setState(() {
                          value = newValue;
                          widget.onChanged(newValue);
                        });
                      }
                    },
                    items: widget.property.values
                        .map<DropdownMenuItem<SelectionEntity>>(
                            (SelectionEntity item) {
                      return DropdownMenuItem<SelectionEntity>(
                        value: item,
                        alignment: AlignmentDirectional.centerStart,
                        child: Label(
                          text: getLang() == 'ar' ? item.nameAr : item.nameEn,
                          style: Styles.mediumText(fontSize: 32),
                        ),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Label(
                        text: getLang() == 'ar'
                            ? value?.nameAr ?? ''
                            : value?.nameEn ?? '',
                        style: Styles.mediumText(
                            fontSize: 32,
                            color: AppColors.getTextColor(context)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 4),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Label(
    //           text: getLang() == 'ar'
    //               ? widget.property.nameAr
    //               : widget.property.nameEn, style: Styles.mediumText(fontSize: 32),),
    //       const SizedBox(
    //         height: 4,
    //       ),
    //       InkWell(
    //         onTap: () {
    //           bottomSheet(
    //               context: context,
    //               isScrollControlled: true,
    //               widget: _buildOptionsSheet(
    //                   action: (SelectionEntity v) {
    //                     widget.onChanged(v);
    //                     context.pop();
    //                   },
    //                   values: widget.property.values));
    //         },
    //         child: Container(
    //           width: double.infinity,
    //           height: 42,
    //           padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
    //           // margin: EdgeInsets.all(5),
    //           decoration: BoxDecoration(
    //             // border: Border.all(color: Colors.grey),
    //             borderRadius: BorderRadius.circular(15),
    //             color: const Color(0xffF5F5F5),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Label(
    //                     text: getLang() == 'ar'
    //                         ? value?.nameAr ?? ''
    //                         : value?.nameEn ?? '', style: Styles.mediumText(fontSize: 32),),
    //               ),
    //               const Icon(Icons.keyboard_arrow_down_rounded)
    //             ],
    //           ),
    //         ),
    //       ),
    //
    //     ],
    //   ),
    // );
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
  //             title: Label(text: getLang() == 'ar' ? v.nameAr : v.nameEn, style: Styles.mediumText(fontSize: 32),),
  //           );
  //         }),
  //   );
  // }

  Widget _buildNumberFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
            style: Styles.mediumText(fontSize: 32),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextFormField(
                    maxLines: 1,
                    focusNode: _focusNode,
                    onChanged: (v) =>
                        widget.onTextChanged(v, true, widget.property.type),
                    keyboardType: TextInputType.number,
                    style: Styles.mediumText(
                        fontSize: 32, color: AppColors.getTextColor(context)),
                    decoration: InputDecoration(
                      fillColor: AppColors.getFillColor(context),
                      filled: true,
                      contentPadding:
                          const EdgeInsetsDirectional.only(start: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: Styles.mediumText(
                          fontSize: 32, color: AppColors.getTextColor(context)),
                      hintText: LocaleKeys.from.localize,
                      // prefix: Sizer(
                      //   width: 20.w,
                      // ),
                    ),
                    validator: (value) {
                      if ((value == null || value.isEmpty)) {
                        return LocaleKeys.required.localize;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextFormField(
                    maxLines: 1,
                    onChanged: (v) =>
                        widget.onTextChanged(v, false, widget.property.type),
                    keyboardType: TextInputType.number,
                    style: Styles.mediumText(
                        fontSize: 32, color: AppColors.getTextColor(context)),
                    decoration: InputDecoration(
                      fillColor: AppColors.getFillColor(context),
                      filled: true,
                      contentPadding:
                          const EdgeInsetsDirectional.only(start: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),

                      hintText: LocaleKeys.to.localize,
                      hintStyle: Styles.mediumText(
                          fontSize: 32, color: AppColors.getTextColor(context)),
                      // prefix: Sizer(
                      //   width: 20.w,
                      // ),
                    ),
                    validator: (value) {
                      if ((value == null || value.isEmpty)) {
                        return LocaleKeys.required.localize;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelectFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn,
            style: Styles.mediumText(fontSize: 32),
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
              childAspectRatio: 3.4,
            ),
            itemCount: widget.property.values.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
      ManageVibration.vibrate();
                  widget.onChanged(widget.property.values[index]);
                  value = widget.property.values[index];
                  setState(() {});
                },
                child: Container(
                    height: 42,
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
                          fontSize: 32, color: AppColors.getTextColor(context)),
                    )),
              );
            },
          ),
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
          //             color: AppColors.getFillColor(context),
          //             border: value == e
          //                 ? Border.all(
          //                     color: AppColors.SECONDARY_COLOR_DARK2,
          //                   )
          //                 : null,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           child: Label(
          //             text: getLang() == 'ar' ? e.nameAr : e.nameEn,
          //             style: Styles.mediumText(
          //                 fontSize: 32, color: AppColors.getTextColor(context)),
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
          //       height: 42,
          //
          //       padding: const EdgeInsets.all(5),
          //       margin: const EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         color: const Color(0xffF5F5F5),
          //         border: value == e?
          //         Border.all(
          //             color:
          //                AppColors.SECONDARY_COLOR_DARK2,
          //         ) : null,
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: Label(
          //         text: getLang() == 'ar' ? e.nameAr : e.nameEn,
          //         style: Styles.mediumText(fontSize: 32),
          //       ),
          //     ),
          //   ));
          // }).toList()),
          // ),
        ],
      ),
    );
  }
}
