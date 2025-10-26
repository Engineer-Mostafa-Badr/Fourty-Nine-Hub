import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/new_phone_number_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_home.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class PhoneNumberBottomSheet {
  /// Shows a bottom sheet for entering phone number.
  ///
  /// Returns:
  /// - `true` if form was submitted successfully.
  /// - `false` if user closed the sheet.
  static Future<bool> show({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color:
                  context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.phoneNumber.localize,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ManageVibration.vibrate();
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),
                  Text(
                    context.isArabic
                        ? 'الرجاء إدخال رقم تواصل مباشر مع مقدم الخدمة'
                        : "Please enter a direct contact number for the service provider.",
                  ),
                  NewPhoneNumberTextFormField(
                    currentController: controller,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    maxLength: 11,
                    validator: (value) {
                      String normalized = value?.replaceAllMapped(
                            RegExp(r'[٠-٩]'),
                            (match) => (match.group(0)!.codeUnitAt(0) - 0x0660)
                                .toString(),
                          ) ??
                          '';
                      return validatorEgyptPhone(normalized);
                    },
                    onChanged: (_) {
                      // print("value $_");
                      formKey.currentState?.validate();
                    },
                    inputFormatter: [
                      ArabicNumberFormatter(isArabic: context.isArabic),
                    ],
                  ),
                  Text(
                    context.isArabic
                        ? "كتابة رقم عميل آخر علي مسؤوليتك و يعرض للمسائله القانونيه."
                        : "Entering another customer's number is at your own risk and may subject you to legal liability.",
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ManageVibration.vibrate();
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.submit.localize,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}
