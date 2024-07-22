import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';

class DoctorLoginPriceField extends StatelessWidget {
  final FocusNode currentFocusNode;
  final TextEditingController currentController;
  const DoctorLoginPriceField({super.key, required this.currentFocusNode, required this.currentController});

  @override
  Widget build(BuildContext context) {
    return  DefaultTextFormField(
        currentFocusNode: currentFocusNode,
        currentController: currentController,
        keyboardType: TextInputType.number,
        hint: "Price");
  }
}