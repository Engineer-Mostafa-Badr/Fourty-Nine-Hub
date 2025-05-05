import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';

class CustomPhoneTextFormField extends StatefulWidget {
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final EdgeInsetsGeometry? margin;
  final String? initialCountryCode;
  final ValueChanged<String> onInputChanged;
  final bool isEnabled;
  final String? hint;
  final Color? fillColor;
  final Color? codeColor;

  const CustomPhoneTextFormField({
    super.key,
    required this.currentFocusNode,
    required this.nextFocusNode,
    required this.currentController,
    this.margin,
    this.initialCountryCode,
    required this.onInputChanged,
    this.isEnabled = true,
    this.hint,
    this.fillColor,
    this.codeColor = Colors.white,
  });

  @override
  _CustomPhoneTextFormFieldState createState() =>
      _CustomPhoneTextFormFieldState();
}

class _CustomPhoneTextFormFieldState extends State<CustomPhoneTextFormField> {
  String _selectedCountryCode = '+1'; // Default to US country code

  @override
  void initState() {
    super.initState();
    if (widget.initialCountryCode != null) {
      _selectedCountryCode = widget.initialCountryCode!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR);

    return Container(
      margin: widget.margin,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: widget.currentFocusNode,
              controller: widget.currentController,
              enabled: widget.isEnabled,
              cursorColor: Colors.blue,
              style: textStyle,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: widget.fillColor ??
                    (widget.isEnabled
                        ? cardDarkColor(context)
                        : cardDarkColor(context)),
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                hintText: widget.hint ?? LocaleKeys.phoneNumber.localize,
                hintStyle: textStyle.copyWith(
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.QUANTITY_COLOR),
                counterText: '',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              maxLength: 15,
              onChanged: (value) {
                widget.onInputChanged('$_selectedCountryCode$value');
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(widget.nextFocusNode),
            ),
          ),
        ],
      ),
    );
  }
}
