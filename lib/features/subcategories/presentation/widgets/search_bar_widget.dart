import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key, required this.onChanged, required this.focusNode});

  final void Function(String)? onChanged;

  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: LocaleKeys.search.localize,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
        onChanged: onChanged,
        focusNode: focusNode,
      ),
    );
  }
}
