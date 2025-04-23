import 'package:flutter/material.dart';

void showDialogSpotLight(BuildContext context, Widget screen) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: screen,
        ),
      );
    },
  );
}
