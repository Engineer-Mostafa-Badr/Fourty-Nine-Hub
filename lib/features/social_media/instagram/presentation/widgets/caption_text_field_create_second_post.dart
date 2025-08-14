import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';

class CaptionTextFieldCreateSecondPost extends StatelessWidget {
  const CaptionTextFieldCreateSecondPost({
    super.key,
    required this.captionController,
  });

  final TextEditingController captionController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: captionController,
      style: Styles.mediumText(fontSize: 32),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        contentPadding: const EdgeInsetsDirectional.only(start: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintStyle: Styles.mediumText(
          color: context.isDarkMode
              ? const Color(0x80FFFFFF)
              : Colors.black.withValues(alpha: 128),
        ),
        hintText: LocaleKeys.addACaption.localize,
        // prefix: Sizer(
        //   width: 20.w,
        // ),
      ),
      // keyboardType: TextInputType.number,
      // validator: (value) {
      //   if ((value == null || value.isEmpty)) {
      //     return LocaleKeys.required.localize;
      //   } else {
      //     return null;
      //   }
      // },
    );
  }
}
