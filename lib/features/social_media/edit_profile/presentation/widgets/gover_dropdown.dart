import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/edit_profile_cubit.dart';

class GoverDropdown extends StatefulWidget {
  void Function(String?)? onSelected;
  String country;

  GoverDropdown({super.key, this.onSelected, required this.country});

  @override
  _GoverDropdownState createState() => _GoverDropdownState();
}

class _GoverDropdownState extends State<GoverDropdown> {
  String? _selectedCountry = LocaleKeys.governorate.localize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
      return DropdownMenu<String>(
        width: double.infinity,
        textStyle: Styles.mediumText(
            color:
                context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR),
        initialSelection: _selectedCountry,
        onSelected: (String? country) {
          setState(() {
            _selectedCountry = country;
            state.selectedCity = country;
          });
          if (widget.onSelected != null) {
            widget.onSelected!(country);
          }
        },
        dropdownMenuEntries: state.governorates
                ?.map<DropdownMenuEntry<String>>((governorate) {
              return DropdownMenuEntry<String>(
                value:
                    context.isArabic ? governorate.nameAr : governorate.nameEn,
                label:
                    context.isArabic ? governorate.nameAr : governorate.nameEn,
              );
            }).toList() ??
            [],
        leadingIcon: const Icon(Icons.public),
        selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
        hintText: widget.country, // _selectedCountry ?? widget.country,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(UIConst.radius)),
            borderSide: BorderSide(
                color: context.isDarkMode
                    ? const Color(0xffCACFF4)
                    : Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                const BorderRadius.all(Radius.circular((UIConst.radius))),
            borderSide: BorderSide(
                color: context.isDarkMode
                    ? const Color(0xffCACFF4)
                    : Colors.black),
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
          outlineBorder: const BorderSide(color: AppColors.GREYFIELD),
          constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
          hintStyle: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR),
          labelStyle: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.QUANTITY_COLOR),
          // fillColor: AppColors.GREYFIELD,
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        ),
        menuHeight: 200,
        trailingIcon: const Icon(Icons.arrow_drop_down),
      );
    });
  }
}
