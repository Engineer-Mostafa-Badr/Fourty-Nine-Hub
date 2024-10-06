import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class AdDynamicInputWidget extends StatefulWidget {
  final AdPropertiesEntity property;
  final Function(SelectionEntity) onChanged;
  final Function(String) onTextChanged;
  const AdDynamicInputWidget(
      {super.key,
      required this.property,
      required this.onChanged,
      required this.onTextChanged});

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
    super.initState();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn),
        TextFormField(
          maxLines: null,
          onChanged: (v) => widget.onTextChanged(v),
          style: Styles.headerText(fontSize: 26),
          decoration: InputDecoration(
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5),
              hintText: getLang() == 'ar'
                  ? widget.property.nameAr
                  : widget.property.nameEn,
              hintStyle: Styles.mediumText(),
              prefix: Sizer(
                width: 20.w,
              )),
          // keyboardType: TextInputType.number,
          validator: (value) {
            if ((value == null || value.isEmpty)) {
              return LocaleKeys.required.localize;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn),
        InkWell(
          onTap: () {
            bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: _buildOptionsSheet(
                    action: (SelectionEntity v) {
                      widget.onChanged(v);
                      context.pop();
                    },
                    values: widget.property.values));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5),
            // margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Label(
                      text: getLang() == 'ar'
                          ? value?.nameAr ?? ''
                          : value?.nameEn ?? ''),
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSheet({
    required Function(SelectionEntity v) action,
    required List<SelectionEntity> values,
  }) {
    return Scaffold(
      appBar: const BackAppBar(
        label: LocaleKeys.select.localize,
      ),
      body: ListView.builder(
          itemCount: values.length,
          itemBuilder: (context, index) {
            final v = values[index];
            return ListTile(
              onTap: () {
                action(v);
                value = v;
                setState(() {});
              },
              title: Label(text: getLang() == 'ar' ? v.nameAr : v.nameEn),
            );
          }),
    );
  }

  Widget _buildNumberFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn),
        FormTextField(
          label: getLang() == 'ar'
              ? widget.property.nameAr
              : widget.property.nameEn,
          type: TextInputType.number,
          height: kToolbarHeight * .8,
          hint: 'Type here',
          action: (String v) => widget.onTextChanged(v),
        ),
      ],
    );
  }

  Widget _buildSelectFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            text: getLang() == 'ar'
                ? widget.property.nameAr
                : widget.property.nameEn),
        RichText(
            text: TextSpan(
                children: widget.property.values.map((e) {
          return WidgetSpan(
              child: InkWell(
            onTap: () {
              widget.onChanged(e);
              value = e;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        value == e ? AppColors.SECONDARY_COLOR : Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Label(
                text: getLang() == 'ar' ? e.nameAr : e.nameEn,
              ),
            ),
          ));
        }).toList())),
      ],
    );
  }
}
