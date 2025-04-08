import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ContentTextFieldCreateSecondPost extends StatelessWidget {
  const ContentTextFieldCreateSecondPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      onChanged: (v) {},
      style: Styles.mediumText(fontSize: 32),
      decoration: InputDecoration(
        fillColor: const Color(0xffF5F5F5),
        filled: true,
        contentPadding: const EdgeInsetsDirectional.only(start: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: Styles.mediumText(
          fontSize: 32,
          color: Colors.grey,
        ),
        hintText: LocaleKeys.addExplanatoryNote.localize,
        // prefix: Sizer(
        //   width: 20.w,
        // ),
      ),
      // keyboardType: TextInputType.number,
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return LocaleKeys.required.localize;
        } else {
          return null;
        }
      },
    );
  }
}
