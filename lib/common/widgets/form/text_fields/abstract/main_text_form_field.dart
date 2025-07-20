import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';

abstract class MainTextFormField extends StatefulWidget {
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final bool? noBoarder;
  final BoxConstraints? constraints;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool expanded;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final TextStyle? hintStyle;
  final Color? hintColor;
  final bool enableSuggestions;
  final bool showScrollbar;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isAuthentcation;
  final String? label;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? cursorColor;
  final TextStyle? style;
  final VoidCallback? onTap;
  final VoidCallback? onEditComplete;
  final Widget? labelWidget;
  final Iterable<String>? autofillHints;

  const MainTextFormField({
    super.key,
    this.currentFocusNode,
    this.minLines,
    this.label,
    this.labelWidget,
    this.prefix,
    this.readOnly = false,
    this.isAuthentcation = false,
    this.noBoarder = false,
    this.nextFocusNode,
    required this.currentController,
    required this.hintText,
    this.keyboardType,
    required this.validator,
    this.constraints,
    this.textCapitalization = TextCapitalization.none,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    this.enabled = true,
    this.maxLength,
    this.inputFormatters,
    this.expanded = false,
    this.maxLines = 1,
    this.contentPadding,
    this.borderColor,
    this.hintStyle,
    this.hintColor,
    this.enableSuggestions = false,
    this.showScrollbar = false,
    this.obscureText,
    this.suffixIcon,
    this.onChanged,
    this.fillColor,
    this.cursorColor,
    this.style,
    this.prefixIcon,
    this.onTap,
    this.onEditComplete,
    this.autofillHints,
  });

  @override
  State<MainTextFormField> createState() => _MainTextFormFieldState();
}

class _MainTextFormFieldState extends State<MainTextFormField> {
  TextDirection? _currentDir;

  @override
  Widget build(BuildContext context) {
    Widget textFieldWidget = TextFormField(
        onTap: widget.onTap ??
                () {
              var selection = widget.currentController.selection;
              var length = widget.currentController.text.length;
              var isLast = selection ==
                  TextSelection.fromPosition(TextPosition(offset: length - 1));
              if (isLast) {
                selection =
                    TextSelection.fromPosition(TextPosition(offset: length));
              }
            },
        autofillHints: widget.autofillHints,
        onEditingComplete: widget.onEditComplete,
        cursorColor: widget.cursorColor,
        textDirection: _currentDir,
        focusNode: widget.currentFocusNode,
        controller: widget.currentController,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        expands: widget.expanded,
        enableSuggestions: widget.enableSuggestions,
        style: widget.style ?? Styles.mediumText(
            color:
            context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR),
        textCapitalization: widget.textCapitalization,
        textAlignVertical:
        widget.expanded ? const TextAlignVertical(y: -0.8) : null,
        obscureText: widget.obscureText ?? false,
        minLines: widget.minLines,
        decoration: InputDecoration(
          fillColor: widget.fillColor ??
              (widget.enabled
                  ? cardDarkColor(context)
                  : cardDarkColor(context)),
          filled: true,
          contentPadding:
          widget.contentPadding ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
          hintText: widget.hintText,
          labelText: widget.label,
          hintStyle: widget.hintStyle ?? TextStyle(
              color:
              context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR),
          suffixIcon: widget.suffixIcon,
          prefix: widget.prefix,
          label: widget.labelWidget,
          prefixIcon: widget.prefixIcon,
          constraints: widget.constraints,
          prefixIconColor: AppColors.QUANTITY_COLOR,

          enabledBorder: OutlineInputBorder(
            borderRadius:
            const BorderRadius.all(Radius.circular(UIConst.radius)),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.GREY_LIGHT_COLOR),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            const BorderRadius.all(Radius.circular((UIConst.radius))),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.GREY_LIGHT_COLOR),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(UIConst.radius)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(UIConst.radius)),
          ),
          counterText: '',
          border: InputBorder.none,
          disabledBorder: OutlineInputBorder(
            borderRadius:
            const BorderRadius.all(Radius.circular(UIConst.radius)),
            borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.GREY_LIGHT_COLOR),
          ),
        ),
        validator: widget.validator,

        onChanged: (text) {
          if (widget.isAuthentcation) {
            if (CacheServiceImpl().isLogin() ?? false) {
              if (text.isEmpty) {
                setState(() => _currentDir = null);
              } else {
                final dir = _getDirection(text);
                if (dir != _currentDir) setState(() => _currentDir = dir);
              }
              (widget.onChanged ?? (_) {})(text);
            } else {
              return pleaseLoginDialog(context);
              // context.push(Routes.LOGIN);
            }
          } else {
            if (text.isEmpty) {
              setState(() => _currentDir = null);
            } else {
              final dir = _getDirection(text);
              if (dir != _currentDir) setState(() => _currentDir = dir);
            }
            (widget.onChanged ?? (_) {})(text);
          }
        },

        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        });

    if (widget.showScrollbar) {
      textFieldWidget = Scrollbar(child: textFieldWidget);
    }

    return Container(
      margin: widget.margin,
      child: textFieldWidget,
    );
  }

  TextDirection _getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
