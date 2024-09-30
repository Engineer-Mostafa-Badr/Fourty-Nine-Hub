import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';

import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdDynamicInputWidget extends StatefulWidget {
  final AdPropertiesEntity property;
  final Function(String) onChanged;
  const AdDynamicInputWidget(
      {super.key, required this.property, required this.onChanged});

  @override
  State<AdDynamicInputWidget> createState() => _AdDynamicInputWidgetState();
}

class _AdDynamicInputWidgetState extends State<AdDynamicInputWidget> {
  String value = '';
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
    return TextFormField(
      maxLines: null,
      onChanged: (v) => widget.onChanged(v),
      style: Styles.headerText(fontSize: 26),
      decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(5),
          hintText: widget.property.label,
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
    );
  }

  Widget _buildDropDownWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: widget.property.label),
        InkWell(
          onTap: () {
            bottomSheet(
                context: context,
                isScrollControlled: true,
                widget: _buildOptionsSheet(
                    action: (String v) {
                      widget.onChanged(v);
                      context.pop();
                    },
                    values: widget.property.values));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Label(text: value),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSheet({
    required Function(String v) action,
    required List<String> values,
  }) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Select',
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
              title: Label(text: v),
            );
          }),
    );
  }

  Widget _buildNumberFieldWidget() {
    return FormTextField(
      label: widget.property.label,
      type: TextInputType.number,
      height: kToolbarHeight * .8,
      hint: 'Type here',
      action: (String v) => widget.onChanged(v),
    );
  }

  Widget _buildSelectFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: widget.property.label),
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
                text: e,
              ),
            ),
          ));
        }).toList())),
      ],
    );
  }
}
