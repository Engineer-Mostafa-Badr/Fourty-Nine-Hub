import 'package:flutter/material.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'default_text_form_field.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.currentFocusNode,
    this.nextFocusNode,
    required this.currentController,
    this.margin,
    this.hint,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final EdgeInsetsGeometry? margin;
  final String? hint;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureTextLogin = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: DefaultTextFormField(
        currentController: widget.currentController,
        currentFocusNode: widget.currentFocusNode!,
        nextFocusNode: widget.nextFocusNode,
        margin: widget.margin,
        hint: widget.hint ?? 'Password',
        obscureText: _obscureTextLogin,
        borderColor: AppColors.PRIMARY_COLOR,
        maxLines: 1,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        validator: widget.validator ?? Validator().validatePassword,
      ),
    );
  }

  void _toggleLogin() => setState(() => _obscureTextLogin = !_obscureTextLogin);
}
