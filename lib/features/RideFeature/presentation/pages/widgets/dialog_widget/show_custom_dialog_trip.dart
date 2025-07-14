import 'package:flutter/material.dart';

void showCustomDialogTrip(BuildContext context, Widget screen) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        contentPadding: const EdgeInsets.only(
          top: 20,
          bottom: 0,
          left: 10,
          right: 10,
        ),
        content: screen,
      );
    },
  );
}
