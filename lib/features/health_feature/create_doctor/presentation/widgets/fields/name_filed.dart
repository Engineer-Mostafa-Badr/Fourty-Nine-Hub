import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';

class CreateDoctorNameField extends StatelessWidget {
  const CreateDoctorNameField({super.key, this.focusNode});
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return Row(
      children: [
        Expanded(
          child: CustomTextFieldHealth(
            focusNode: focusNode,
            hintText: LocaleKeys.firstName.localize,
            controller: doctorLoginCubit.firstNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.firstNameIsRequired.localize;
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: CustomTextFieldHealth(
            hintText: LocaleKeys.lastName.localize,
            controller: doctorLoginCubit.lastNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.lastNameIsRequired.localize;
              }
              return null;
            },
          ),
        ),
      ],
    );

    // return Column(
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "${context.isArabic ? 'الاسم الاول' : 'First name'}:",
    //                 style: Styles.mediumText(),
    //               ),
    //               CustomTextFieldHealth(
    //                 hintText: LocaleKeys.firstName.localize,
    //                 controller: doctorLoginCubit.firstNameController,
    //                 keyboardType: TextInputType.name,
    //                 validator: (value) {
    //                   if (value == null || value.isEmpty) {
    //                     return LocaleKeys.firstNameIsRequired.localize;
    //                   }
    //                   return null;
    //                 },
    //               ),
    //               // TextFormField(
    //               //   validator: (value) {
    //               //     if (value == null || value.isEmpty) {
    //               //       return context.isArabic
    //               //           ? 'برجاء ادخال الاسم الاول'
    //               //           : 'Please enter first name';
    //               //     }
    //               //     return null;
    //               //   },
    //               //   controller: doctorLoginCubit.firstNameController,
    //               //   decoration: InputDecoration(
    //               //     // Border when the field is not focused
    //               //     enabledBorder: const OutlineInputBorder(
    //               //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //               //       borderSide: BorderSide(
    //               //         color: Colors
    //               //             .grey, // Use grey as the default border color
    //               //       ),
    //               //     ),
    //               //     // Border when the field is focused
    //               //     focusedBorder: const OutlineInputBorder(
    //               //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //               //       borderSide: BorderSide(
    //               //         color: Colors.grey, // Grey border when focused
    //               //       ),
    //               //     ),
    //               //     // Default border (same as enabledBorder)
    //               //     border: const OutlineInputBorder(
    //               //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //               //       borderSide: BorderSide(
    //               //         color: Colors.grey,
    //               //       ),
    //               //     ),
    //               //     // Error border when validation fails
    //               //     errorBorder: const OutlineInputBorder(
    //               //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //               //       borderSide: BorderSide(
    //               //         color: Colors.red, // Red border when there's an error
    //               //       ),
    //               //     ),
    //               //     // Error border when focused and invalid
    //               //     focusedErrorBorder: const OutlineInputBorder(
    //               //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //               //       borderSide: BorderSide(
    //               //         color: Colors
    //               //             .red, // Keep red border when focused with an error
    //               //       ),
    //               //     ),
    //               //     filled: false,
    //               //     contentPadding: const EdgeInsets.all(
    //               //         10), // Padding inside the text field
    //               //     hintText: context.isArabic ? 'الاسم الاول' : 'First name',
    //               //     hintStyle: Styles.mediumText(), // Hint text
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //         const Sizer(),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "${context.isArabic ? 'اللقب' : 'Last name'}:",
    //                 style: Styles.mediumText(),
    //               ),
    //               TextFormField(
    //                 validator: (value) {
    //                   if (value == null || value.isEmpty) {
    //                     return context.isArabic
    //                         ? 'برجاء ادخال اللقب'
    //                         : 'Please enter last name';
    //                   }
    //                   return null;
    //                 },
    //                 controller: doctorLoginCubit.lastNameController,
    //                 decoration: InputDecoration(
    //                   // Border when the field is not focused
    //                   enabledBorder: const OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(
    //                       color: Colors
    //                           .grey, // Use grey as the default border color
    //                     ),
    //                   ),
    //                   // Border when the field is focused
    //                   focusedBorder: const OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(
    //                       color: Colors.grey, // Grey border when focused
    //                     ),
    //                   ),
    //                   // Default border (same as enabledBorder)
    //                   border: const OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(
    //                       color: Colors.grey,
    //                     ),
    //                   ),
    //                   // Error border when validation fails
    //                   errorBorder: const OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(
    //                       color: Colors.red, // Red border when there's an error
    //                     ),
    //                   ),
    //                   // Error border when focused and invalid
    //                   focusedErrorBorder: const OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(
    //                       color: Colors
    //                           .red, // Keep red border when focused with an error
    //                     ),
    //                   ),
    //                   filled: false,
    //                   contentPadding: const EdgeInsets.all(
    //                       10), // Padding inside the text field
    //                   hintText: context.isArabic ? 'اللقب' : 'Last name',
    //                   hintStyle: Styles.mediumText(), // Hint text
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //     const Sizer(),
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "${context.isArabic ? 'رقم الهاتف' : 'Phone number'}:",
    //           style: Styles.mediumText(),
    //         ),
    //         TextFormField(
    //           validator: (value) {
    //             if (value == null || value.isEmpty) {
    //               return context.isArabic
    //                   ? 'برجاء ادخال رقم الهاتف'
    //                   : 'Please enter phone number';
    //             }
    //             return null;
    //           },
    //           controller: doctorLoginCubit.phoneController,
    //           decoration: InputDecoration(
    //             // Border when the field is not focused
    //             enabledBorder: const OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               borderSide: BorderSide(
    //                 color: Colors.grey, // Use grey as the default border color
    //               ),
    //             ),
    //             // Border when the field is focused
    //             focusedBorder: const OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               borderSide: BorderSide(
    //                 color: Colors.grey, // Grey border when focused
    //               ),
    //             ),
    //             // Default border (same as enabledBorder)
    //             border: const OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               borderSide: BorderSide(
    //                 color: Colors.grey,
    //               ),
    //             ),
    //             // Error border when validation fails
    //             errorBorder: const OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               borderSide: BorderSide(
    //                 color: Colors.red, // Red border when there's an error
    //               ),
    //             ),
    //             // Error border when focused and invalid
    //             focusedErrorBorder: const OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               borderSide: BorderSide(
    //                 color: Colors
    //                     .red, // Keep red border when focused with an error
    //               ),
    //             ),
    //             filled: false,
    //             contentPadding:
    //                 const EdgeInsets.all(10), // Padding inside the text field
    //             hintText: context.isArabic ? 'رقم الهاتف' : 'Phone number',
    //             hintStyle: Styles.mediumText(), // Hint text
    //           ),
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }
}
