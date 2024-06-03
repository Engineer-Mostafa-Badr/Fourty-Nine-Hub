import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:size_helper/size_helper.dart';

import '../../../../res/style/app_colors.dart';

class PhoneTextFormField extends StatelessWidget {
  const PhoneTextFormField({
    super.key,
    required this.currentFocusNode,
    required this.nextFocusNode,
    required this.currentController,
    this.margin,
    this.initialValue,
    required this.onInputChanged,
    this.isEnabled = true,
    this.hint,
    this.fillColor,
    this.codeColor = Colors.white,
  });

  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController currentController;
  final EdgeInsetsGeometry? margin;
  final PhoneNumber? initialValue;
  final ValueChanged<PhoneNumber> onInputChanged;
  final bool isEnabled;
  final String? hint;
  final Color? fillColor;
  final Color? codeColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = context
        .sizeHelper(
            mobileLarge:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.0),
            tabletSmall: Theme.of(context).textTheme.bodySmall!,
            tabletNormal: Theme.of(context).textTheme.bodySmall!,
            desktopSmall:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 21.0))
        .copyWith(color: Colors.black);
    return Container(
      margin: margin,
      child: InternationalPhoneNumberInput(
        locale: Localizations.localeOf(context).languageCode,
        countries: const ['EG'],
        isEnabled: isEnabled,
        focusNode: currentFocusNode,
        textFieldController: currentController,
        cursorColor: AppColors.PRIMARY_COLOR,
        textStyle: textStyle,
        selectorTextStyle: textStyle.copyWith(color: codeColor),
        inputDecoration: InputDecoration(
          fillColor: fillColor ??
              (isEnabled ? Colors.white : AppColors.GREY_NORMAL_COLOR),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          hintText: hint ?? 'Phone Number',
          hintStyle: context
              .sizeHelper(
                mobileLarge: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 10.0),
                tabletSmall: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12.0),
                tabletNormal: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12.0),
                desktopSmall: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 20.0),
              )
              .copyWith(color: Colors.black),
          counterText: '',
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        autoValidateMode: AutovalidateMode.disabled,
        ignoreBlank: false,
        initialValue: initialValue ?? PhoneNumber(isoCode: 'KW'),
        selectorConfig: const SelectorConfig(
          trailingSpace: false,
          leadingPadding: 0.0,
          selectorType: PhoneInputSelectorType.DIALOG,
        ),
        searchBoxDecoration: const InputDecoration(
          hintText: 'Search By Country Name or Code',
        ),
        spaceBetweenSelectorAndTextField: 8.0,
        errorMessage: 'Invalid Phone Number',
        hintText: '01.........',
        onInputChanged: onInputChanged,
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(nextFocusNode),
        maxLength: 11,
        formatInput: false,
      ),
    );
  }
}
