import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class AdDynamicInputs extends StatelessWidget {
  final List<AdPropertiesEntity> properties;
  const AdDynamicInputs({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final property = properties[index];
        return AdDynamicInputWidget(property: property);
      },
      separatorBuilder: (context, index) => const Sizer(),
      shrinkWrap: true,
      itemCount: properties.length,
    );
  }
}

class AdDynamicInputWidget extends StatefulWidget {
  final AdPropertiesEntity property;
  const AdDynamicInputWidget({super.key, required this.property});

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
        if (widget.property.adPropertyType == AdPropertyType.text)
          _buildTextFieldWidget(),
        if (widget.property.adPropertyType == AdPropertyType.select)
          _buildSelectFieldWidget(),
        if (widget.property.adPropertyType == AdPropertyType.number)
          _buildNumberFieldWidget(),
        if (widget.property.adPropertyType == AdPropertyType.dropdown)
          _buildDropDownWidget(),
      ],
    );
  }

  Widget _buildTextFieldWidget() {
    return FormTextField(
      label: widget.property.label,
      height: kToolbarHeight * .8,
      hint: 'Type here',
      action: (v) => value = v,
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
                      value = v;
                      setState(() {});
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
            return ListTile(
              onTap: () => action(values[index]),
              title: Label(text: values[index]),
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
      action: (v) => value = v,
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
