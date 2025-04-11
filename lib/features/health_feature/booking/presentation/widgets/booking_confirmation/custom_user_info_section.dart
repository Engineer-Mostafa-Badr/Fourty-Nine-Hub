import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import 'custom_booking_info_editable_row.dart';
import 'custom_booking_info_row.dart';

class CustomUserInfoSection extends StatelessWidget {
  final String patientName;

  final String patientPhone;
  bool isBookingForSomeoneElse = false;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  FocusNode? currentFocusNode;
  FocusNode? nextFocusNode;
  final String Time;
  final String location;
  final String fees;

  final BuildContext context;

  CustomUserInfoSection(
      {required this.context,
      required this.Time,
      required this.location,
      required this.fees,
      required this.nameController,
      required this.phoneController,
      this.currentFocusNode,
      this.nextFocusNode,
      required this.isBookingForSomeoneElse,
      required this.patientName,
      required this.patientPhone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Name Field (editable when checkbox is checked)
        CustomBookingInfoEditableRow(
          context: context,
          icon: Icons.person,
          label: LocaleKeys.name.localize,
          value: patientName,
          isEditableName: isBookingForSomeoneElse,
          isEditablePhone: false,
          controller: nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),

        const Sizer(height: 11),

        /// Phone Field (editable when checkbox is checked)
        CustomBookingInfoEditableRow(
          context: context,
          icon: Icons.phone,
          label:LocaleKeys.name.localize,
          value: patientPhone,
          isEditablePhone: isBookingForSomeoneElse,
          currentFocusNode: currentFocusNode,
          nextFocusNode: nextFocusNode,
          controller: phoneController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            return null;
          },
          isEditableName: false,
        ),

        const Sizer(height: 11),

        /// Appointment Time
        CustomBookingInfoRow(
          context: context,
          icon: Icons.access_time,
          // title: '02:00 PM : 11:55 PM Sunday 06 April',
          title: Time,
        ),

        const Sizer(height: 11),

        /// Location
        CustomBookingInfoRow(
          context: context,
          icon: Icons.location_on,
          title: location,
        ),

        const Sizer(height: 11),

        /// Fees
        CustomBookingInfoRow(
          context: context,
          icon: Icons.monetization_on,
          title: 'Fees',
          fees: fees,
        ),
      ],
    );
  }
}
