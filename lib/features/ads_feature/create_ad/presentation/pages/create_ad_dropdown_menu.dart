import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateAdDropdownMenu<T> extends StatelessWidget {
  const CreateAdDropdownMenu({
    super.key,
    required this.onChange,
    required this.items,
    required this.hint,
    required this.value,
  });

  final void Function(T?)? onChange;
  final List<DropdownMenuItem<T>>? items;
  final String hint;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        width: double.infinity,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: context.isDarkMode?AppColors.GREY_DARK_COLOR:const Color(0xffF5F5F5),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: context.isDarkMode?AppColors.GREY_DARK_COLOR:const Color(0xFFE0E0E0),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.isDarkMode?AppColors.whiteColor:Colors.black,
                ),
              ),
              menuMaxHeight: 300,
              elevation: 2,
              dropdownColor: context.isDarkMode?AppColors.GREY_DARK_COLOR:const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(15),
              itemHeight: 50,
              underline: Container(),
              onChanged: onChange,
              items: items,
              hint: Label(
                text: hint,
                style: Styles.mediumText(fontSize: 32,color: context.isDarkMode?AppColors.whiteColor:null),
              ),
            ),
          ),
        ),
      ),
    );
    return DropdownButtonHideUnderline(
      child: Container(
        width: double.infinity,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffF5F5F5),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(0xFFE0E0E0),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              menuMaxHeight: 300,
              elevation: 2,
              // dropdownColor: context.isDarkMode
              //     ? AppColors.GREY_DARK_COLOR
              //     : AppColors.LIGHT_COLOR,
              borderRadius: BorderRadius.circular(15),
              itemHeight: 50,
              underline: Container(),
              onChanged: onChange,
              items: items,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Label(
                  text: hint,
                  style: Styles.mediumText(fontSize: 32),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
