import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/styles.dart';
import '../../../../res/style/app_colors.dart';

class ExitWidget extends StatelessWidget {
  final Widget child;

  const ExitWidget({super.key, required this.child});

  // Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  //   return await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //       titlePadding: const EdgeInsets.only(top: 5),
  //       title:  Text(
  //         LocaleKeys.warning.localize,
  //         style:  Styles.headerText(color: Colors.red,fontWeight: FontWeight.bold),
  //         textAlign: TextAlign.center,
  //         overflow: TextOverflow.ellipsis,
  //         // maxLines: maxLines,
  //       ),
  //       content:    Column(
  //         children: [
  //           const SizedBox(height: 5,),
  //           Center(
  //             child: Label(
  //               text: LocaleKeys.ExitApp.localize,
  //               style: Styles.headerText(),
  //             ),
  //           ),
  //           Label(
  //             text: LocaleKeys.sureLogoutApp.localize,
  //             style: Styles.mediumText(),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //
  //           onPressed: () => SystemNavigator.pop(), // Exit
  //           child: Label(
  //             text: LocaleKeys.sure.localize,
  //             style: Styles.mediumText(),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false), // Stay
  //           child: Label(
  //             text: LocaleKeys.no.localize,
  //             style: Styles.mediumText(),
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   ) ??
  //       false; // Return false if the dialog is dismissed
  // }
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titlePadding: const EdgeInsets.only(top: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          LocaleKeys.warning.localize,
          style: Styles.headerText(color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Label(
                text: LocaleKeys.ExitApp.localize,
                style: Styles.headerText(),
              ),
            ),
            const SizedBox(height: 5),
            Label(
              text: LocaleKeys.sureLogoutApp.localize,
              style: Styles.mediumText(),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        actions: [
          buildButton(LocaleKeys.sure.localize, AppColors.PRIMARY_COLOR,Colors.white,(){SystemNavigator.pop();}),
          buildButton(LocaleKeys.no.localize, Colors.white,AppColors.PRIMARY_COLOR,(){Navigator.of(context).pop(false);}),

        ],
      ),
    ) ?? false;
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

  Widget buildButton(String label,Color background,Color foreGround,Function()onTap){
    return    TextButton(
      style: TextButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreGround,
        padding: const EdgeInsets.all(0),
        minimumSize: const Size(70, 30),
        maximumSize: const Size(70, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => onTap(),
      child: Label(
        text: label,
        style: Styles.mediumText(),
      ),
    );
  }
}