import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../res/style/app_colors.dart';

class FormTextField extends StatefulWidget {
  final String? initialValue;
  final bool? obsecure;
  final bool? enabled;
  final bool? required;
  final Function(String)? action;
  final Widget? prefix, suffix;
  final String? hint, label, info;
  final TextInputType? type;
  final TextEditingController? controller;
  final Function? onTap;
  final Iterable<String>? autofill;
  final bool? isEmail;
  final Function? onConfirm;
  final bool? extraValidation;
  final String? extraValidationMessage;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  final double? height;
  final TextStyle? style;
  final Color? fillColor;
  final bool noBorder;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;
  const FormTextField(
      {super.key,
        this.initialValue,
        this.hintStyle,
        this.action,
        this.obsecure,
        this.borderRadius,
        this.prefix,
        this.noBorder = false,
        this.constraints,
        this.fillColor,
        this.hint,
        this.label,
        this.info,
        this.autofill,
        this.suffix,
        this.type,
        this.isEmail,
        this.enabled,
        this.onConfirm,
        this.textAlignVertical,
        this.extraValidationMessage,
        this.extraValidation,
        this.onTap,
        this.height,
        this.maxLines,
        this.style,
        this.required,
        this.controller, this.textStyle});

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.maxLines != null
              ? null
              : validate
              ? (widget.height ?? kToolbarHeight) * 1.5
              : widget.height ?? kToolbarHeight,
          child: TextFormField(
            style:widget.textStyle?? Styles.mediumText(color: AppColors.QUANTITY_COLOR),
            textAlignVertical: widget.textAlignVertical,
            maxLines: widget.maxLines ?? 1,
            onFieldSubmitted: (v) {
              if (widget.onConfirm != null) {
                widget.onConfirm!();
              }
            },
            validator: (value) {
              validate = true;
              final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

              setState(() {});
              if ((value == null || value.isEmpty) &&
                  (widget.required ?? true)) {
                return 'Required';
              } else if (widget.extraValidation ?? false) {
                return widget.extraValidationMessage ?? '';
              } else if (!emailRegExp.hasMatch(value!.trim()) &&
                  (widget.isEmail ?? false)) {
                return 'Enter correct email format';
              } else {
                validate = false;
                setState(() {});
                return null;
              }
            },
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            enabled: widget.enabled ?? true,
            controller: widget.controller,
            autofillHints: widget.autofill,
            keyboardType: widget.type,
            initialValue: widget.initialValue,
            obscureText: widget.obsecure ?? false,
            onChanged: widget.action,
            decoration: InputDecoration(
              constraints: widget.constraints,
              hintText: widget.hint,
              filled: true,
              fillColor: widget.fillColor ?? Colors.transparent,
              labelText: widget.label,
              hintStyle: widget.style ?? const TextStyle(fontSize: 12),
              labelStyle: widget.style ?? const TextStyle(fontSize: 12),
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              enabledBorder: widget.noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
                borderRadius:
                widget.borderRadius ?? BorderRadius.circular(10),
              ),
              focusedBorder: widget.noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                ),
                borderRadius:
                widget.borderRadius ?? BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              ),
              focusedErrorBorder: widget.noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius:
                widget.borderRadius ?? BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        if (widget.info != null)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                const Sizer(),
                const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 14,
                ),
                const Sizer(),
                Expanded(
                    child: Label(
                      text: widget.info ?? '',
                      style: Styles.smallText(color: Colors.grey),
                    ))
              ],
            ),
          )
      ],
    );
  }
}