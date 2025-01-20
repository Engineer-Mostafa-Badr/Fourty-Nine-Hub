import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/styles.dart';

class ExitWidget extends StatelessWidget {
  final Widget child;

  const ExitWidget({super.key, required this.child});

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.only(top: 5),

        title:  Column(children: [
          Text(
            LocaleKeys.warning.localize,
            style:  Styles.headerText(color: Colors.red,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            // maxLines: maxLines,
          ),
          const SizedBox(height: 5,),
          Center(
            child: Label(
              text: LocaleKeys.ExitApp.localize,
              style: Styles.headerText(),
            ),
          ),
        ],),
        content:    Label(
          text: LocaleKeys.sureLogoutApp.localize,
          style: Styles.mediumText(),
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(), // Exit
            child: Label(
              text: LocaleKeys.sure.localize,
              style: Styles.mediumText(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay
            child: Label(
              text: LocaleKeys.no.localize,
              style: Styles.mediumText(),
            ),
          ),

        ],
      ),
    ) ??
        false; // Return false if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool shouldExit = await _showExitConfirmationDialog(context);
        if (shouldExit) {
          exit(0);
        }
      },
      child: child,
    );
  }
}