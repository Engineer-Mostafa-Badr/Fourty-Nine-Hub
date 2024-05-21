import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import 'default_text_form_field.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    required this.currentFocusNode,
    this.nextFocusNode,
    required this.currentController,
    this.margin,
    this.hint,
    this.validator,
  });

  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final EdgeInsetsGeometry? margin;
  final String? hint;
  final String? Function(String?)? validator;

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
        currentFocusNode: widget.currentFocusNode,
        nextFocusNode: widget.nextFocusNode,
        margin: widget.margin,
        hint: widget.hint ?? 'Password',
        obscureText: _obscureTextLogin,
        borderColor: AppColors.PRIMARY_COLOR,
        maxLines: 1,
        suffixIcon: GestureDetector(
          onTap: _toggleLogin,
          child: Icon(
            _obscureTextLogin
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
            size: 18,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
        validator: widget.validator ?? Validator().validatePassword,
      ),
    );
  }

  void _toggleLogin() => setState(() => _obscureTextLogin = !_obscureTextLogin);
}
