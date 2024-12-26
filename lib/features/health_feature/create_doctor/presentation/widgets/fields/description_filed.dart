import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorDescriptionField extends StatelessWidget {
  const CreateDoctorDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${LocaleKeys.desc.localize}:",
          style: Styles.mediumText(),
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.isArabic
                  ? 'برجاء ادخال الوصف'
                  : 'Please enter description';
            }
            return null;
          },
          controller: context.read<CreateDoctorCubit>().descriptionController,
          decoration: InputDecoration(
            // Border when the field is not focused
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.grey, // Use grey as the default border color
              ),
            ),
            // Border when the field is focused
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.grey, // Grey border when focused
              ),
            ),
            // Default border (same as enabledBorder)
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            // Error border when validation fails
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.red, // Red border when there's an error
              ),
            ),
            // Error border when focused and invalid
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.red, // Keep red border when focused with an error
              ),
            ),
            filled: false,
            contentPadding:
                const EdgeInsets.all(10), // Padding inside the text field
            hintText: context.isArabic ? 'اضافة وصف' : 'Add description',
            hintStyle: Styles.mediumText(), // Hint text
          ),
        ),
      ],
    );
  }
}
