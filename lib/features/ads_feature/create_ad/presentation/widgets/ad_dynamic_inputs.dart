import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';

import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

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
    return FormTextField(
      label: widget.property.label,
      height: kToolbarHeight * .8,
      hint: 'Type here',
      action: (String v) => widget.onChanged(v),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
