import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

void showDialogTripJoin(BuildContext context, Widget screen) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: screen,
        ),
      );
    },
  );
}
