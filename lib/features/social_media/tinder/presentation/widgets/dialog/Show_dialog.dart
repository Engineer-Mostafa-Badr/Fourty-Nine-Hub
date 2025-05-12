import 'package:flutter/material.dart';

void showDialogFind(BuildContext context, Widget screen) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:const  Color(0xFF1C1C1D),
        surfaceTintColor:const  Color(0xFF1C1C1D),
        child: screen,
      );
    },
  );
}
