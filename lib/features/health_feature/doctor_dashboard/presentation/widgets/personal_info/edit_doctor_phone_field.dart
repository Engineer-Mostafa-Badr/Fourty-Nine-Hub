import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class EditDoctorPhoneField extends StatelessWidget {
  const EditDoctorPhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.isDarkMode?Colors.white:Colors.black) ??
            TextStyle(color:context.isDarkMode?Colors.white: Colors.black);
    return TextFormField(
      focusNode: FocusNode(),
      controller: context.read<EditDoctorPersonalInfoCubit>().phoneController,
      // enabled: widget.isEnabled,
      cursorColor: Colors.blue,
      style: textStyle,
      decoration: InputDecoration(
        fillColor: cardDarkColor(context) ,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        hintText:  LocaleKeys.phoneNumber.localize,
        hintStyle: textStyle.copyWith(color: context.isDarkMode?Colors.white:AppColors.QUANTITY_COLOR),
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      maxLength: 15,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        print(context.read<EditDoctorPersonalInfoCubit>().phoneController.text);
      },
    );
  }
}
