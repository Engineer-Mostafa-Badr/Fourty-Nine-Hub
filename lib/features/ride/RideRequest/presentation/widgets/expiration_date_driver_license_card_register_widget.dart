import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ExpirationDateDriverLicenseCardRegisterWidget extends StatefulWidget {
  const ExpirationDateDriverLicenseCardRegisterWidget(
      {super.key, required this.onTap, this.initValue});
  final void Function(DateTime date) onTap;
  final String? initValue;
  @override
  State<ExpirationDateDriverLicenseCardRegisterWidget> createState() =>
      _ExpirationDateDriverLicenseCardRegisterWidgetState();
}

class _ExpirationDateDriverLicenseCardRegisterWidgetState
    extends State<ExpirationDateDriverLicenseCardRegisterWidget> {
  DateTime? expirationDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expirationDate = DateTime.tryParse(widget.initValue??"");
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        if (expirationDate == null) {
          return context.isArabic
              ? "يرجى إدخال تاريخ انتهاء الصلاحية"
              : "Please enter the expiration date";
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.isDarkMode
                      ? AppColors.UNSELECTED_DARK_GRAY_COLOR
                      : Colors.white,
                  boxShadow: context.isDarkMode
                      ? []
                      : [
                          BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                        ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Text(
                      context.isArabic
                          ? "تاريخ انتهاء الصلاحية"
                          : "Expiration date",
                      style: Styles.headerText(
                          fontWeight: FontWeight.w500, fontSize: 40),
                    ),
                  ),
                  const Sizer(),
                  GestureDetector(
                    onTap: () async {
                      var pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1800),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        expirationDate = pickedDate;
                        widget.onTap(expirationDate ?? pickedDate);
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: field.hasError
                              ? Border.all(
                                  color: AppColors.SECONDARY_COLOR_DARK)
                              : null,
                          color: context.isDarkMode
                              ? Colors.black12
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.keyboard_arrow_down),
                          const Sizer(),
                          Text(
                            expirationDate != null
                                ? DateFormat("dd/MM/yyyy")
                                    .format(expirationDate!)
                                : "",
                            style: Styles.mediumText(fontSize: 32),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (field.hasError)
                    ValidationErrorWidget(
                      message: field.errorText ?? "",
                    ),
                  const Sizer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      context.isArabic
                          ? "يرجى إدخال تاريخ انتهاء الصلاحية\nلمستنداتك"
                          : "Please enter the expiration date for your documents.",
                      style: Styles.headerText(
                          fontWeight: FontWeight.w500, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
