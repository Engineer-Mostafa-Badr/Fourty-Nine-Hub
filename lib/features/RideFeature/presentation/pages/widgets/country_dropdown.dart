import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import '../../../../../res/style/app_colors.dart';

class CountryDropdown extends StatefulWidget {
  void Function(String?)? onSelected;

  CountryDropdown({super.key, this.onSelected});
  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return DropdownMenu<String>(
            width: double.infinity,
            textStyle: const TextStyle(fontSize: 12),
            initialSelection: _selectedCountry,
            onSelected: (String? country) {
              setState(() {
                _selectedCountry = country;
              });
              if (widget.onSelected != null) {
                widget.onSelected!(country);
              }
            },
            dropdownMenuEntries: state.governorates?.map<DropdownMenuEntry<String>>((governorate) {
              return DropdownMenuEntry<String>(
                value: context.isArabic? governorate.nameAr: governorate.nameEn,
                label: context.isArabic? governorate.nameAr: governorate.nameEn,
              );
            }).toList() ?? [],
            leadingIcon: const Icon(Icons.public),
            selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
            hintText: _selectedCountry ?? 'country'.tr(),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.GREYFIELD),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.GREYFIELD),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.GREYFIELD),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.GREYFIELD),
              ),
              outlineBorder: const BorderSide(color: AppColors.GREYFIELD),
              filled: true,
              constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
              hintStyle: const TextStyle(fontSize: 12),
              labelStyle: const TextStyle(fontSize: 12),
              fillColor: AppColors.GREYFIELD,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
            menuHeight: 200,
            trailingIcon: const Icon(Icons.arrow_drop_down),
          );
        }
    );

  }
}
