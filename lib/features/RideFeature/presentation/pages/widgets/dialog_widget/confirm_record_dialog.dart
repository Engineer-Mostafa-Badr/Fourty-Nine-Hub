import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../font_manager.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
class ConfirmRecordDialog extends StatelessWidget {
  const ConfirmRecordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.alert.localize,
          style:const TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),


        Text(
          LocaleKeys.doYouWantToRecordTheRide.localize,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSize.s14,
            color:context.isDarkMode?Colors.white: Colors.black,
          ),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
      ManageVibration.vibrate();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.buttonDialog,// const Color(0xFF0A0A2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child:  Text(LocaleKeys.record.localize),
              ),
            ),

            const SizedBox(width: 15,),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
      ManageVibration.vibrate();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child:  Text(LocaleKeys.cancel.localize),
              ),
            ),

          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}