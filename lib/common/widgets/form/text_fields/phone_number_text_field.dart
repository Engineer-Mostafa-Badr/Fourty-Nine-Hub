import 'package:flutter/material.dart';

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
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black) ??
            const TextStyle(color: Colors.black);

    return Container(
      margin: widget.margin,
      child: Row(
        children: [
          // Country Code Dropdown
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: widget.fillColor ?? Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: widget.codeColor ?? Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.QUANTITY_COLOR,
                ),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue!;
                  });
                },
                style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                items: <String>[
                  '+1',
                  '+44',
                  '+91'
                ] // Add more country codes as needed
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          // Phone Number Text Field
          Expanded(
            flex: 8,
            child: TextFormField(
              focusNode: widget.currentFocusNode,
              controller: widget.currentController,
              enabled: widget.isEnabled,
              cursorColor: Colors.blue,
              style: textStyle,
              decoration: InputDecoration(
                fillColor: widget.fillColor ??
                    (widget.isEnabled ? Colors.white : Colors.grey),
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                hintText: widget.hint ?? 'Phone Number',
                hintStyle: textStyle.copyWith(color: AppColors.QUANTITY_COLOR),
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
              // Adjust as needed
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
